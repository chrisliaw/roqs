
require 'fiddle'
require 'fiddle/import'

module Roqs
  module CommonWrapper
   extend Fiddle::Importer
   include Roqs::Wrapper

   #dlload File.join(File.dirname(__FILE__),"..","..","native","linux","x86_64","liboqs.so.0.7.0")
   load_oqs_lib

   extern 'int OQS_MEM_secure_bcmp(const void *a, const void *b, size_t len)'
   extern 'int OQS_MEM_cleanse(const void *ptr, size_t len)'
   extern 'int OQS_MEM_secure_free(void *ptr, size_t len)'
   extern 'int OQS_MEM_insecure_free(void *ptr)'


  end
end
