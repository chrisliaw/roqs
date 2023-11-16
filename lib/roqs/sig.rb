
require_relative 'struct'
require_relative 'sig_wrapper'
require_relative 'common_wrapper'

module Roqs
  class SIG

   def self.supported_signature_algo
     ttl = SIGWrapper.OQS_SIG_alg_count
     supported = []
     (0...ttl).each do |i|
        pName = SIGWrapper.OQS_SIG_alg_identifier(i)
        name = pName.to_s
        st = SIGWrapper.OQS_SIG_alg_is_enabled(name)
        if st
          supported << name
        end
     end

     supported
   end

   def initialize(name)
     @algo = name
     oqsSig = SIGWrapper.OQS_SIG_new(@algo) 
     raise Error, "Unable to create object '#{@algo}'. It is either the algorithm not supported or it is disabled at compile time." if oqsSig.null?
     @struct = OQS_SIG.new(oqsSig)
   end

   def cleanup
     SIGWrapper.OQS_SIG_free(@struct) if not @struct.nil?
   end

   def free(obj)
     obj.free if not (obj.nil? and obj.null?)
   end

   def intrinsic_name
     @struct.intrinsic_name.to_s
   end

   def algo_version
     @struct.algo_version.to_s
   end

   def method_missing(mtd, *args, &block)
     @struct.send(mtd) if not @struct.nil? and @struct.respond_to?(mtd)
   end

   def genkeypair
     pubKey = Fiddle::Pointer.malloc(@struct.length_public_key, Fiddle::RUBY_FREE)
     raise Error, "Unable to allocate memory for public key size #{@struct.length_public_key}" if pubKey.null?
     privKey = Fiddle::Pointer.malloc(@struct.length_secret_key, Fiddle::RUBY_FREE)
     raise Error, "Unable to allocate memory for secret key size #{@struct.length_secret_key}" if privKey.null?

     rv = SIGWrapper.OQS_SIG_keypair(@struct, pubKey, privKey)
     raise Error, "Error in generation of keypair" if rv != Roqs::OQS_SUCCESS

     [pubKey, privKey]
   end

   def verify(message,signature,pubKey)

     pMessage = Fiddle::Pointer.to_ptr(message)
     pSignature = Fiddle::Pointer.to_ptr(signature)
     
     rv = SIGWrapper.OQS_SIG_verify(@struct, pMessage, message.length, pSignature, signature.length, pubKey)

     rv == Roqs::OQS_SUCCESS

   end

   def sign(message, privKey)

     raise Error, "Private key cannot be nil" if privKey.nil?

     signature = Fiddle::Pointer.malloc(@struct.length_signature, Fiddle::RUBY_FREE)
     raise Error, "Unable to allocate memory for signature size #{@struct.length_signature}" if signature.null?
     signLen = Fiddle::Pointer.malloc(Fiddle::SIZEOF_SIZE_T, Fiddle::RUBY_FREE)
     raise Error, "Unable to allocate memory for signature length size #{Fiddle::SIZEOF_SIZE_T}" if signLen.null?
   
     pMessage = Fiddle::Pointer.to_ptr(message)

     rv = SIGWrapper.OQS_SIG_sign(@struct, signature, signLen, pMessage, message.length, privKey)
     raise Error, "Error in signing" if rv != Roqs::OQS_SUCCESS

     signBin = signature[0, signLen.ptr.to_i]

     signLen.free
     signature.free

     signBin
     
   end

  end
  
end
