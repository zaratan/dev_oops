module DevOops
  module ScriptsLoader
    FORBIDDEN_NAMES = %w[help install edit edit_sh rm]
    ScriptConfig =
      Struct.new(:name, :desc, :usage, :script_location, :args) do
        def self.create(script_name, script_location, json_config)
          new(
            script_name,
            json_config['desc'] || 'Missing description',
            "#{script_name} #{json_config['usage'] || ''}",
            script_location,
            json_config['args'],
          )
        end
      end

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

          ScriptConfig.create(script_name, script_location, json_config)
        end
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
