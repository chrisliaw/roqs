
require_relative 'struct'
require_relative 'kem_wrapper'
require_relative 'common_wrapper'

module Roqs
  class KEMPublicKey
    
    def initialize(nativePubKey)
      @native_pubkey = nativePubKey
    end

    def length
      @native_pubkey.size
    end

    def bytes
      #puts "raw 1 : #{@native_pubkey.size}"
      #puts "raw 2 : #{@native_pubkey.to_str}"
      @native_pubkey.to_str
    end

    def native_pubkey
      @native_pubkey
    end

  end
end
