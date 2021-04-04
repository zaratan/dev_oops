# frozen_string_literal: true
module DevOops
  module Commands
    class LocalInstall < Thor::Group
      def install
        return if Dir.exist?('./dev_oops')

        FileUtils.mkdir './dev_oops'
      end
    end
  end
end
