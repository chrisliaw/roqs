# frozen_string_literal: true

RSpec.describe Roqs do

  it 'SIG algorithms' do
    algos = Roqs::SIG.supported_signature_algo 
    expect(algos).not_to be_nil

    expect { Roqs::SIG.new("random") }.to raise_exception(Roqs::Error)

    puts "Found #{algos.length} supported SIG algo"
    p algos

    algos.each do |al|

      begin
        puts "Testing PQ signing algo #{al}"

        sig = Roqs::SIG.new(al)
        pubKey, privKey = sig.genkeypair
        expect(pubKey).not_to be_nil
        expect(privKey).not_to be_nil

        message = " this is super message reuqires signing "
        sign = sig.sign(message, privKey)
        puts "Signature output : #{sign.length}"
        expect(sign).not_to be_nil

        res = sig.verify(message, sign, pubKey)
        expect(res).to be true

        expect(sig.verify("whatever", sign, pubKey)).to be false

        sig.free(pubKey)
        sig.free(privKey)
        sig.cleanup

      rescue Exception => ex
        STDERR.puts "Algo '#{al}' getting error result"
        STDERR.puts ex.message
      end

    end
    
  end

end
