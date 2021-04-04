# frozen_string_literal: true
module DevOops
  module ScriptsLoader
    FORBIDDEN_NAMES = %w[help install edit edit_sh rm local_install].freeze
    GLOBAL_DIR = "#{Dir.home}/.dev_oops"
    ScriptConfig =
      Struct.new(:name, :desc, :usage, :script_location, :args, :dir) do
        def self.create(script_name, script_location, json_config, dir)
          new(
            script_name,
            json_config['desc'] || 'Missing description',
            "#{script_name} #{json_config['usage'] || ''}",
            script_location,
            json_config['args'],
            dir,
          )
        end
      end

    def self.find_dev_oops_dirs
      [
        GLOBAL_DIR,
        *Dir.pwd.gsub("#{Dir.home}/", '').split('/').reduce(
          [],
        ) { |res, new_dir| [*res, "#{res.last}/#{new_dir}"] }.map do |dir|
          "#{Dir.home}#{dir}/dev_oops"
        end.select { |dir| Dir.exist?(dir) },
      ]
    end

    def self.load
      find_dev_oops_dirs.flat_map do |dir|
        Dir.glob("#{dir}/*.json")
      end.map do |filename|
        script_location = filename.gsub(/\.json$/, '.sh')
        script_location = '' unless File.exist?(script_location)
        json_config = nil
        File.open(filename) { |file| json_config = JSON.parse(file.read) }
        script_name = File.basename(filename, '.json')

        ScriptConfig.create(
          script_name,
          script_location,
          json_config,
          File.dirname(filename),
        )
      end.reverse.reduce([]) do |res, script_config|
        if res.any? { |script_c| script_c.name == script_config.name }
          res
        else
          [*res, script_config]
        end
      end
    end

    def self.script_dir(script_name)
      scripts = self.load
      scripts.find { |script| script.name == script_name }&.dir ||
        Dir.exist?("#{Dir.pwd}/dev_oops") && "#{Dir.pwd}/dev_oops" || GLOBAL_DIR
    end

    def self.build_action(config)
      Class.new(Thor::Group) do
        (config.args || []).each do |arg|
          class_option(
            arg['name'],
            desc: arg['desc'] || '',
            aliases: arg['aliases'] || [],
            required: arg['required'] || false,
            default: arg['default'],
          )
        end

        define_singleton_method('banner') { config.usage }

        define_method('perform') do
          env_vars = options.map { |k, v| "#{k}=#{v}" }.join(' ')

          if config.script_location && !config.script_location.empty?
            location =
              if config.script_location.start_with?('/')
                config.script_location
              else
                "#{ENV['HOME']}/#{config.script_location}"
              end
            system("#{env_vars} #{ENV['SHELL']} -c #{location}")
          end
        end
      end
    end
  end
end
