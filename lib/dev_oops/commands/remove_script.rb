module DevOops
  module Commands
    class RemoveScript < Thor::Group
      argument :script_name, desc: 'name of the script'

      def remove_sh
        return unless File.exist?("#{CONFIG_DIR}/#{script_name}.sh")
        FileUtils.remove "#{CONFIG_DIR}/#{script_name}.sh"
      end

      def remove_json
        return unless File.exist?("#{CONFIG_DIR}/#{script_name}.json")
        FileUtils.remove "#{CONFIG_DIR}/#{script_name}.json"
      end
    end
  end
end
