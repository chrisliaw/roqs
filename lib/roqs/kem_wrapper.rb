
require 'fiddle'
require 'fiddle/import'

require_relative 'wrapper'

module Roqs
  module KEMWrapper
   extend Fiddle::Importer
   include Roqs::Wrapper

   #dlload File.join(File.dirname(__FILE__),"..","..","native","linux","x86_64","liboqs.so.0.7.0")
   load_oqs_lib

   extern 'const char * OQS_KEM_alg_identifier(size_t i)'
   extern 'int OQS_KEM_alg_count(void)'
   extern 'int OQS_KEM_alg_is_enabled(const char * name)'

   extern 'OQS_KEM * OQS_KEM_new(const char * algo)'
   extern 'void OQS_KEM_free(OQS_KEM * kem)'

   extern 'int OQS_KEM_keypair(const OQS_KEM *kem, uint8_t *public_key, uint8_t *secret_key)'
   
   extern 'int OQS_KEM_encaps(const OQS_KEM *kem, uint8_t * ciphertext, uint8_t *shared_secret, uint8_t *public_key)'
   extern 'int OQS_KEM_decaps(const OQS_KEM *kem, uint8_t * shared_secret, uint8_t *ciphertext, uint8_t *secret_key)'

  end
end
