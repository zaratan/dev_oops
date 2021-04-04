# frozen_string_literal: true
module DevOops
  module Commands
    class RemoveScript < Thor::Group
      include Thor::Actions

      def self.source_root
        "#{File.dirname(__FILE__)}/../../../"
      end

      argument :script_name, desc: 'name of the script'
      class_option :global,
                   desc: 'force the script to be global',
                   aliases: ['g'],
                   type: :boolean

      def self.banner
        "#{$PROGRAM_NAME} rm SCRIPT_NAME"
      end

      def remove_json
        script_dir =
          if options[:global]
            ScriptsLoader::GLOBAL_DIR
          else
            ScriptsLoader.script_dir(script_name)
          end
        json_path = "#{script_dir}/#{script_name}.json"
        sh_path = "#{script_dir}/#{script_name}.sh"
        remove_file json_path if File.exist?(json_path)
        remove_file sh_path if File.exist?(sh_path)
      end
    end
  end
end
