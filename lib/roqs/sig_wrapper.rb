
require 'fiddle'
require 'fiddle/import'

module Roqs
  module SIGWrapper
   extend Fiddle::Importer
   include Roqs::Wrapper

   ## OQS_STATUS
   #OQS_ERROR = -1
   #OQS_SUCCESS = 0
   #OQS_EXTERNAL_LIB_ERROR_OPENSSL = 50
    
   #dlload File.join(File.dirname(__FILE__),"..","..","native","linux","x86_64","liboqs.so.0.7.0")
   load_oqs_lib

   extern 'const char * OQS_SIG_alg_identifier(size_t i)'
   extern 'int OQS_SIG_alg_count(void)'
   extern 'int OQS_SIG_alg_is_enabled(const char * name)'

   extern 'OQS_SIG * OQS_SIG_new(const char * algo)'
   extern 'void OQS_SIG_free(OQS_SIG * sig)'

   extern 'int OQS_SIG_keypair(const OQS_SIG *sig, uint8_t *public_key, uint8_t *secret_key)'
   
   extern 'int OQS_SIG_sign(const OQS_SIG *sig, uint8_t * signature, size_t *signature_len, uint8_t *message, size_t message_len, uint8_t *secret_key)'
   extern 'int OQS_SIG_verify(const OQS_SIG *sig, uint8_t * message, size_t message_len, uint8_t *signature, size_t signature_len, uint8_t *public_key)'

  end
end
