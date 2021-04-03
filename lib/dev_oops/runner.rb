# frozen_string_literal: true
module DevOops
  class Runner < Thor
    include Thor::Actions
    REGISTERED_CLASS_METHODS = {} # rubocop:disable Style/MutableConstant

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
      'Edit a script config',
    )
    register(
      Commands::EditScriptSh,
      'edit_sh',
      'edit_sh SCRIPT_NAME',
      'Edit the script bash',
    )
    register(Commands::RemoveScript, 'rm', 'rm SCRIPT_NAME', 'Remove a script')

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
