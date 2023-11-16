
require 'fiddle'
require 'fiddle/import'

module Roqs
  extend Fiddle::Importer

  OQS_KEM = struct [
    "const char * intrinsic_name",
    "const char * algo_version",
    "uint8_t claimed_nist_level",
    "int ind_cca",
    "size_t length_public_key",
    "size_t length_secret_key",
    "size_t length_ciphertext",
    "size_t length_shared_secret",
    "int (*keypair)(uint8_t *pubKey, uint8_t* secretKey)",
    "int (*encaps)(uint8_t *cipher_text, uint8_t* shared_secret, const unit8_t * pubKey)",
    "int (*decaps)(uint8_t *shared_secret, uint8_t* cipher_text, const unit8_t * secretKey)"
  ]

  OQS_SIG = struct [
    "const char * intrinsic_name",
    "const char * algo_version",
    "uint8_t claimed_nist_level",
    "int euf_cma",
    "size_t length_public_key",
    "size_t length_secret_key",
    "size_t length_signature",
    "int (*keypair)(uint8_t *pubKey, uint8_t* secretKey)",
    "int (*sign)(uint8_t *signature, size_t signature_len, const uint8_t* message, size_t message_len, const unit8_t * secretKey)",
    "int (*verify)(uint8_t *message, size_t message_len, const uint8_t* signature, size_t signature_len, const unit8_t * pubKey)"
  ]
 
end
