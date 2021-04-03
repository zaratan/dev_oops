# frozen_string_literal: true
module DevOops
  module Commands
    class EditScriptSh < Thor::Group
      include Thor::Actions

      argument :script_name
      def edit
        path = "#{CONFIG_DIR}/#{script_name}.sh"
        FileUtils.touch(path) unless File.exist?(path)
        FileUtils.chmod(0o750, path)
        system("#{ENV['EDITOR'] || 'vim'} #{CONFIG_DIR}/#{script_name}.sh")
      end
    end
  end
end
