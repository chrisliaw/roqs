
require 'fiddle'

module Roqs
  module Wrapper
    class WrapperError < StandardError; end

    module ClassMethods
      def load_oqs_lib
        os = detect_os
        logger.debug "Found OS #{os}"
        load_arch_lib(os)          
      end

      def detect_os
        plat = RUBY_PLATFORM
        if plat =~ /linux/
          :linux
        elsif plat =~ /darwin/
          :macos
        elsif plat =~ /mingw/
          :windows
        else
          raise WrapperError, "Unknown platform detected. [#{plat}]"
        end
      end

      def load_arch_lib(os)
        plat = RUBY_PLATFORM
        pplat = plat.split('-')[0]
        logger.debug "OS architecture is #{pplat}"
        drvDir = File.join(File.dirname(__FILE__),"..","..","native","#{os}",pplat)
        if File.exist?(drvDir)
          Dir.glob(File.join(drvDir,"liboqs*")) do |f|
            logger.debug "Loading #{f} from system"
            dlload f
          end
        else
          raise WrapperError, "Directory '#{pplat}' not found at #{drvDir}"
        end
      end

      def logger
        Roqs.logger(:roqs_wrapper)
      end
    end
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    def logger
      self.class.logger
    end

  end
end
