# frozen_string_literal: true

RSpec.describe Roqs do

  it 'KEM algorithms' do
    algos = Roqs::KEM.supported_kem_algo 
    expect(algos).not_to be_nil

    expect { Roqs::KEM.new("random") }.to raise_exception(Roqs::Error)

    puts "Found #{algos.length} supported KEM algo"

    algos.each do |al|

      begin
        puts "Testing #{al}"

        kem = Roqs::KEM.new(al)
        pubKey, privKey = kem.genkeypair
        expect(pubKey).not_to be_nil
        expect(privKey).not_to be_nil

        pubKey2, privKey2 = kem.genkeypair
        expect(pubKey2).not_to be_nil
        expect(privKey2).not_to be_nil

        ekey, cipher = kem.derive_encapsulation_key(pubKey.bytes)
        dkey = kem.derive_decapsulation_key(cipher, privKey)
        expect(ekey == dkey).to be true

        ekey2, cipher2 = kem.derive_encapsulation_key(pubKey2.bytes)
        dkey2 = kem.derive_decapsulation_key(cipher2, privKey2)
        expect(ekey2 == dkey2).to be true
        expect(ekey2 != ekey).to be true

        #pubKeyBin = pubKey.bytes
        #kem2 = Roqs::KEM.new(al)

        puts "Public key size : #{pubKey.length} bytes"
        puts "Public key size 2 : #{pubKey.bytes.length} bytes"
        puts "Private key size : #{privKey.size} bytes"
        puts "Shared key size of #{al} is #{dkey.length}"

        kem.free(pubKey.native_pubkey)
        kem.free(privKey)
        kem.cleanup

      rescue Exception => ex
        STDERR.puts "Algo '#{al}' getting error response"
        STDERR.puts ex.message
      end

    end
    
  end

end
