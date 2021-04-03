module DevOops
  module Commands
    class EditScript < Thor::Group
      include Thor::Actions

      def self.source_root
        "#{File.dirname(__FILE__)}/../../../"
      end

      argument :script_name
      def edit
        path = "#{CONFIG_DIR}/#{script_name}.json"
        template 'templates/empty_script.tt', path unless File.exist?(path)
        system("#{ENV['EDITOR'] || 'vim'} #{CONFIG_DIR}/#{script_name}.json")
      end
    end
  end
end
