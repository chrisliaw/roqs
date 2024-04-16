# frozen_string_literal: true

require 'benchmark'

RSpec.describe Roqs do

  it 'runs test for all supported liboqs SIG algorithms' do
    algos = Roqs::SIG.supported_signature_algo 
    expect(algos).not_to be_nil

    expect { Roqs::SIG.new("random") }.to raise_exception(Roqs::Error)

    puts "Found #{algos.length} supported SIG algo"
    p algos

    algos.each do |al|

      cnt = 0
      loop do

        begin
          puts "Testing PQ signing algo #{al}"

          sig = Roqs::SIG.new(al)
          pubKey, privKey = sig.genkeypair
          expect(pubKey).not_to be_nil
          expect(privKey).not_to be_nil

          message = SecureRandom.bytes(rand(50000...80000))

          Benchmark.bm(8) do |b|
            b.report("sign : ") { @sign = sig.sign(message, privKey) }
            #expect(sign).not_to be_nil
            b.report("Verify : ") { @res = sig.verify(message, @sign, pubKey) }
          end

          expect(@res).to be true
          
          expect(sig.verify("whatever", @sign, pubKey)).to be false

          puts "\nAlgo : #{al}"
          puts "Public key size : #{pubKey.size} bytes"
          #puts "Private key size : #{privKey.size} bytes"
          puts "Signature input size : #{message.length} bytes"
          puts "Signature output : #{@sign.length}\n"


          sig.free(pubKey)
          sig.free(privKey)
          sig.cleanup

        rescue Exception => ex
          STDERR.puts "Algo '#{al}' getting error result"
          STDERR.puts ex.message
        end
        cnt += 1
        break if cnt >= 1
      end

    end
    
  end

  #it 'KAZ' do

  #  al = "KAZ-SIGN"

  #      begin
  #        puts "Testing PQ signing algo #{al}"

  #        sig = Roqs::SIG.new(al)
  #        pubKey, privKey = sig.genkeypair
  #        expect(pubKey).not_to be_nil
  #        expect(privKey).not_to be_nil

  #        puts "public key : #{pubKey}"
  #        puts "private key : #{privKey}"

  #        loop do
  #        
  #          #message = SecureRandom.bytes(rand(50000...80000))
  #          message = "message for signing"

  #        Benchmark.bm(8) do |b|
  #          b.report("sign : ") { @sign = sig.sign(message, privKey) }
  #          expect(@sign).not_to be_nil
  #          b.report("Verify : ") { @res = sig.verify(message, @sign, pubKey) }
  #        end

  #        expect(@res).to be true
  #        
  #        expect(sig.verify("whatever", @sign, pubKey)).to be false

  #        puts "\nAlgo : #{al}"
  #        puts "Public key size : #{pubKey.size} bytes"
  #        #puts "Private key size : #{privKey.size} bytes"
  #        puts "Signature input size : #{message.length} bytes"
  #        puts "Signature output : #{@sign.length}\n"

  #        end


  #        sig.free(pubKey)
  #        sig.free(privKey)
  #        sig.cleanup

  #      rescue Exception => ex
  #        STDERR.puts "Algo '#{al}' getting error result"
  #        STDERR.puts ex.message
  #      end
  #end
end
