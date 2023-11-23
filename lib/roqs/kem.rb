
require_relative 'struct'
require_relative 'kem_wrapper'
require_relative 'common_wrapper'

require_relative 'kem_public_key'

module Roqs
  class KEM
   
   def self.supported_kem_algo
     ttl = KEMWrapper.OQS_KEM_alg_count
     supported = []
     (0...ttl).each do |i|
        pName = KEMWrapper.OQS_KEM_alg_identifier(i)
        name = pName.to_s
        st = KEMWrapper.OQS_KEM_alg_is_enabled(name)
        if st
          supported << name
        end
     end

     supported
   end

   def initialize(name)
     @algo = name
     oqsKem = KEMWrapper.OQS_KEM_new(@algo) 
     raise Error, "Unable to create object '#{@algo}'. It is either the algorithm not supported or it is disabled at compile time." if oqsKem.null?
     @struct = OQS_KEM.new(oqsKem)
   end

   def cleanup
     KEMWrapper.OQS_KEM_free(@struct) if not @struct.nil?
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

     rv = KEMWrapper.OQS_KEM_keypair(@struct, pubKey, privKey)
     raise Error, "Error in generation of keypair" if rv != Roqs::OQS_SUCCESS

     #pubKeyBin = pubKey[0, pubKey.size]
     #privKeyBin = privKey[0, privKey.size]

     [KEMPublicKey.new(pubKey), privKey]
   end

   def derive_encapsulation_key(pubKey)

     cipher = Fiddle::Pointer.malloc(@struct.length_ciphertext, Fiddle::RUBY_FREE)
     raise Error, "Unable to allocate memory for ciphertext size #{@struct.length_ciphertext}" if cipher.null?

     encpKey = Fiddle::Pointer.malloc(@struct.length_shared_secret, Fiddle::RUBY_FREE)
     raise Error, "Unable to allocate memory for shared secret size #{@struct.length_shared_secret}" if encpKey.null?
     
     rv = KEMWrapper.OQS_KEM_encaps(@struct, cipher, encpKey, pubKey)
     raise Error, "Error in encapsulation" if rv != Roqs::OQS_SUCCESS

     encpKeyBin = encpKey[0,encpKey.size]
     cipherBin = cipher[0,cipher.size]

     cipher.free
     encpKey.free

     [encpKeyBin, cipherBin]

   end

   def derive_decapsulation_key(cipherBin, privKey)

     raise Error, "Cipher cannot be empty" if cipherBin.nil?
     raise Error, "Private key cannot be nil" if privKey.nil?

     encpKey = Fiddle::Pointer.malloc(@struct.length_shared_secret, Fiddle::RUBY_FREE)
     raise Error, "Unable to allocate memory for shared secret size #{@struct.length_shared_secret}" if encpKey.null?
     
     rv = KEMWrapper.OQS_KEM_decaps(@struct, encpKey , cipherBin, privKey)
     raise Error, "Error in decapsulation" if rv != Roqs::OQS_SUCCESS

     encpKeyBin = encpKey[0,encpKey.size]

     encpKey.free

     encpKeyBin
     
   end

   #def test

   #  @cipher = Fiddle::Pointer.malloc(@struct.length_ciphertext, Fiddle::RUBY_FREE)
   #  raise Error, "Unable to allocate memory for ciphertext size #{@struct.length_ciphertext}" if @cipher.null?

   #  shared_e = Fiddle::Pointer.malloc(@struct.length_shared_secret, Fiddle::RUBY_FREE)
   #  raise Error, "Unable to allocate memory for shared secret size #{@struct.length_shared_secret}" if shared_e.null?
   #  
   #  shared_d = Fiddle::Pointer.malloc(@struct.length_shared_secret, Fiddle::RUBY_FREE)
   #  raise Error, "Unable to allocate memory for shared secret size #{@struct.length_shared_secret}" if shared_d.null?

   #  shared_x = Fiddle::Pointer.malloc(@struct.length_shared_secret, Fiddle::RUBY_FREE)
   # 
   #  p shared_e.ptr == shared_d.ptr

   #  rb = shared_e[0, shared_e.size]
   #  p rb

   #  rv = KEMWrapper.OQS_KEM_encaps(@struct, @cipher, shared_e, @pubKey)
   #  raise Error, "Error in encapsulation" if rv != KEMWrapper::OQS_SUCCESS

   #  rb = shared_e[0, shared_e.size]
   #  p rb

   #  p shared_e.ptr == shared_d.ptr

   #  rv = KEMWrapper.OQS_KEM_decaps(@struct, shared_d, @cipher, @privKey)
   #  raise Error, "Error in decapsulation" if rv != KEMWrapper::OQS_SUCCESS

   #  p shared_e.ptr == shared_d.ptr

   #  p shared_d.size
   #  rb = shared_d[0, shared_d.size]
   #  p rb


   #end

  end
  
end
