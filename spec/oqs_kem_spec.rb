# frozen_string_literal: true

RSpec.describe Roqs do

  it 'KEM algorithms' do
    algos = Roqs::KEM.supported_kem_algo 
    expect(algos).not_to be_nil

    expect { Roqs::KEM.new("random") }.to raise_exception(Roqs::Error)

    puts "Found #{algos.length} supported KEM algo"
    p algos

    algos.each do |al|

      begin
        puts "Testing #{al}"

        kem = Roqs::KEM.new(al)
        pubKey, privKey = kem.genkeypair
        expect(pubKey).not_to be_nil
        expect(privKey).not_to be_nil

        ekey, cipher = kem.derive_encapsulation_key(pubKey)
        dkey = kem.derive_decapsulation_key(cipher, privKey)
        expect(ekey == dkey).to be true

        puts "Shared key size of #{al} is #{dkey.length}"

        kem.free(pubKey)
        kem.free(privKey)
        kem.cleanup

      rescue Exception => ex
        STDERR.puts "Algo '#{al}' getting error response"
        STDERR.puts ex.message
      end

    end
    
  end

end
