
require 'fiddle'

module Roqs
  module Wrapper
    class WrapperError < StandardError; end

    module ClassMethods
      include TR::CondUtils

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
        usrDrvDir = ENV['ROQS_LIBOQS_DIR']
        if not_empty?(usrDrvDir)
          logger.debug "Load liboqs shared library from user provided root : #{File.join(usrDrvDir, pplat)}" 
          drvDir = File.join(usrDrvDir,pplat)
        else
          logger.debug "Load liboqs shared library from Roqs internal root : #{File.join(File.dirname(__FILE__),"..","..","native","#{os}",pplat)}" 
          drvDir = File.join(File.dirname(__FILE__),"..","..","native","#{os}",pplat)
        end

        if File.exist?(drvDir)
          Dir.glob(File.join(drvDir,"liboqs*")) do |f|
            logger.debug "Loading liboqs at : #{f}"
            dlload f
          end
        else
          errMsg = []
          errMsg << "Shared library of liboqs (https://github.com/open-quantum-safe/liboqs) could not be found at '#{drvDir}'"
          errMsg << "You might need to compile for your platform."
          errMsg << "Simply follow the steps beflow:"
          errMsg << "1. Clone the repository at https://github.com/open-quantum-safe/liboqs"
          errMsg << "   > clone https://github.com/open-quantum-safe/liboqs liboqs"
          errMsg << "2. Make sure all pre-requisites are installed as documented here : https://github.com/open-quantum-safe/liboqs#quickstart"
          errMsg << "3. Run the following commands: "
          errMsg << "   > cd liboqs && mkdir build && cd build"
          errMsg << "   > cmake -GNinja .. -DBUILD_SHARED_LIBS=ON"
          errMsg << "   > ninja"
          errMsg << "4. Shared library shall be built under lib dir."
          errMsg << "5. Copy the shared library into '#{drvDir}' and you should be good to go"
          errMsg << "   Note: System shall read env variable 'ROQS_LIBOQS_DIR' to decide where to load the liboqs dynamic library from."
          errMsg << "         If no value is given, system shall load from default path : #{File.join(File.dirname(__FILE__),"..","..","native","#{os}",pplat)}"
          raise WrapperError, errMsg.join("\n")
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
