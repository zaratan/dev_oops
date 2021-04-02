require 'dev_oops/version'

require 'fileutils'
require 'json'
require 'thor'

module DevOops
  class Error < StandardError; end
  # Your code goes here...

  CONFIG_DIR = "#{ENV['HOME']}/.dev_oops"

  module ConfigLoader
    def self.load
      Dir
        .glob("#{CONFIG_DIR}/*.json")
        .map do |filename|
          script_location = filename.gsub(/\.json$/, '.sh')
          script_location = '' unless File.exist?(script_location)
          json_config = nil
          File.open(filename) { |file| json_config = JSON.parse(file.read) }
          script_name =
            %r{(?<script_name>[^/]+).json$}.match(filename)['script_name']

          OpenStruct.new(
            {
              name: script_name,
              desc: json_config['desc'],
              usage: "#{script_name} #{json_config['usage']}",
              command: json_config['command'],
              script_location: json_config['script_location'] || script_location,
              args: json_config['args']
            }
          )
        end
    end
  end

  class EditScript < Thor::Group
    include Thor::Actions

    def self.source_root
      "#{File.dirname(__FILE__)}/.."
    end

    argument :script_name
    def edit
      path = "#{CONFIG_DIR}/#{script_name}.json"
      template 'templates/empty_script.tt', path unless File.exist?(path)
      system("#{ENV['EDITOR'] || 'vim'} #{CONFIG_DIR}/#{script_name}.json")
    end
  end

  class EditScriptSh < Thor::Group
    include Thor::Actions

    def self.source_root
      "#{File.dirname(__FILE__)}/.."
    end

    argument :script_name
    def edit
      path = "#{CONFIG_DIR}/#{script_name}.sh"
      FileUtils.touch(path) unless File.exist?(path)
      FileUtils.chmod(0o750, path)
      system("#{ENV['EDITOR'] || 'vim'} #{CONFIG_DIR}/#{script_name}.sh")
    end
  end

  class RemoveScript < Thor::Group
    argument :script_name, desc: 'name of the script'

    def remove_sh
      FileUtils.remove "#{CONFIG_DIR}/#{script_name}.sh" if File.exist?("#{CONFIG_DIR}/#{script_name}.sh")
    end

    def remove_json
      FileUtils.remove "#{CONFIG_DIR}/#{script_name}.json" if File.exist?("#{CONFIG_DIR}/#{script_name}.json")
    end
  end

  class Runner < Thor
    include Thor::Actions
    REGISTERED_CLASS_METHODS = {}

    def self.source_root
      "#{File.dirname(__FILE__)}/.."
    end

    def self.register(klass, subcommand_name, usage, description, options = {})
      REGISTERED_CLASS_METHODS[subcommand_name] = klass if klass <= Thor::Group
      super
    end

    configs = ConfigLoader.load
    configs.each do |config|
      new_action =
        Class.new(Thor::Group) do
          # (config.args || []).each { |arg| argument arg }
          (config.args || []).each do |arg|
            if arg.is_a? String
              class_option arg
            else
              class_option arg['name'],
                           desc: arg['desc'] || '',
                           aliases: arg['aliases'] || [],
                           required: arg['required'] || false,
                           default: arg['default']
            end
          end

          define_method('perform') do
            env_vars = options.map { |k, v| "#{k}=#{v}" }.join(' ')

            system("#{env_vars} #{config.command}") if config.command && !config.command.empty?
            if config.script_location && !config.script_location.empty?
              location =
                if config.script_location.start_with?('/')
                  config.script_location
                else
                  "#{ENV['HOME']}/#{config.script_location}"
                end
              system("#{env_vars} zsh -c #{location}")
            end
          end
        end
      register(new_action, config.name, config.usage, config.desc)
    end

    register(EditScript, 'edit', 'edit SCRIPT_NAME', 'Edit a script config')
    register(
      EditScriptSh,
      'edit_sh',
      'edit_sh SCRIPT_NAME',
      'Edit the script bash'
    )
    register(RemoveScript, 'rm', 'rm SCRIPT_NAME', 'Remove a script')

    # contents of the Thor class
    desc 'install', 'Create the neccesary directory for the gem'
    def install
      return if Dir.exist?(CONFIG_DIR)

      FileUtils.mkdir CONFIG_DIR
    end

    def help(subcommand = nil)
      if subcommand && respond_to?(subcommand)
        klass = REGISTERED_CLASS_METHODS[subcommand]
        klass.start(['-h'])
      else
        super
      end
    end
  end
end
