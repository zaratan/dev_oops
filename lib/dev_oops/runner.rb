# frozen_string_literal: true
module DevOops
  class Runner < Thor
    include Thor::Actions
    REGISTERED_CLASS_METHODS = {} # rubocop:disable Style/MutableConstant

    CONFIG_DIR = "#{ENV['HOME']}/.dev_oops"
    FileUtils.mkdir CONFIG_DIR unless Dir.exist?(CONFIG_DIR)

    def self.source_root
      "#{File.dirname(__FILE__)}/.."
    end

    def self.register(klass, subcommand_name, usage, description, options = {})
      REGISTERED_CLASS_METHODS[subcommand_name] = klass if klass <= Thor::Group
      super
    end

    configs = ScriptsLoader.load
    configs.each do |config|
      next if ScriptsLoader::FORBIDDEN_NAMES.include?(config.name)

      new_action = ScriptsLoader.build_action(config)

      register(new_action, config.name, config.usage, config.desc)
    end

    register(
      Commands::EditScript,
      'edit',
      'edit SCRIPT_NAME',
      'Edit a script config'
    )

    register(
      Commands::EditScriptSh,
      'edit_sh',
      'edit_sh SCRIPT_NAME',
      'Edit the script bash'
    )

    register(Commands::RemoveScript, 'rm', 'rm SCRIPT_NAME', 'Remove a script')

    register(
      Commands::LocalInstall,
      'install',
      'install',
      'Create the neccesary local directory for the gem'
    )

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
