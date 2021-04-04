# frozen_string_literal: true
module DevOops
  module Commands
    class EditScript < Thor::Group
      include Thor::Actions

      def self.source_root
        "#{File.dirname(__FILE__)}/../../../"
      end

      argument :script_name
      class_option :global,
                   desc: 'force the script to be global',
                   aliases: ['g'],
                   type: :boolean

      def self.banner
        "#{$PROGRAM_NAME} edit SCRIPT_NAME"
      end

      def edit
        script_dir =
          if options[:global]
            ScriptsLoader::GLOBAL_DIR
          else
            ScriptsLoader.script_dir(script_name)
          end
        path = "#{script_dir}/#{script_name}.json"
        template 'templates/empty_script.tt', path unless File.exist?(path)
        system("#{ENV['EDITOR'] || 'vim'} #{path}")
      end
    end
  end
end
