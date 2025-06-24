# Roqs

Roqs is the Ruby wrapper to the [Open Quantum Safe library](https://openquantumsafe.org). The native library was tested against the liboqs at [liboqs](https://github.com/open-quantum-safe/liboqs)

Due to the direct invocation of the shared library via the libffi toolkit, unless there are major API changes at the liboqs side, this library will keep working as the library is just a bridge between liboqs and Ruby runtime via the API called. Any new supported algorithms internal to the liboqs can be just immediately utilized by the Ruby runtime.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'roqs'
```

And then execute:

    bundle install

Or install it yourself as:

    gem install roqs

## Usage

OQS mainly only has two group of functions: Key Encapsulation Mechanism (KEM) and Signature (SIG).

Therefore the Ruby wrapper abstraction is following the liboqs C version as baseline.

### Key Encapsulation Mechanism (KEM)

For KEM, the API is simple:

1. List all supported KEM PQ algorithms - PQ algorithms can be enable or disabled at compile time so it all depends on the liboqs native library. This API listed down the algorithms which are *supported* as reported by the native library. If you're using your own version of the library, you might have different output.

```ruby
require 'roqs'

supported_algo = Roqs::KEM.supported_kem_algo
supported_algo.each do |al|
  # al is the algorithm name (string) which is required by subsequent API
  ...
end
```

2. Generate keypair

```ruby
require 'roqs'

kyber = Roqs::KEM.new('Kyber768')
pubKey, secretKey = kyber.genkeypair
# note pubKey and secretKey (or private key) is Fiddle::Pointer type and 
# is required to be used by the C API in the subsequent phase.
# Note that pubKey and secretKey are required to be free manually
# Refer spec file for usage
```

3. Key encapsulation - KEM is meant for key encapsulation which similar with Diffie-Hellman kind of key exchange

```ruby
require 'roqs'

sessionKey, cipher = kyber.derive_encapsulation_key(pubKey)
# cipher is required to be sent to recipient end to re-generate the sessionKey at recipient end.
# Returned sessionKey is meant to convert into the final AES (or any other symmetric key) 
# for the actual data encryption
```

4. Key decapsulation - Re-generate the session key from the private key

```ruby
require 'roqs'

sessionKey = kyber.derive_decapsulation_key(cipher, secretKey)
# cipher is given by sender and privKey is the recipient own private key
```

*sessionKey* returned from derive\_encapsulation\_key() shall be same as the *sessionKey* from derive\_decapsulation\_key(). That session key shall be the AES key (any other symmetric key) for the data encryption.

### Signature mechanism

Signature mechanism is similar with KEM.

1. List all supported Signature PQ algorithms - It is same as KEM as algorithm can be turned on or off during compile time

```ruby
require 'roqs'

supported_algo = Roqs::SIG.supported_signature_algo
supported_algo.each do |al|
  # al is the algorithm name (string) which is required by subsequent API
  ...
end
```

2. Generate keypair

```ruby
require 'roqs'

dili = Roqs::SIG.new('Dilithium5')
pubKey, secretKey = dili.genkeypair
# note pubKey and secretKey (or private key) is Fiddle::Pointer type and 
# is required to be used by the C API in the subsequent phase.
# Note that pubKey and secretKey are required to be free manually
# Refer spec file for usage
```

3. Generate data signature

```rubyion
require 'roqs'

# sign data using sender secretKey/private key
signature = dili.sign("this is message", secretKey)
```

4. Verify data signature

```ruby
require 'roqs'

# verify signature with given data using sender public key
res = dili.verify("this is message", signature, pubKey)
# res is boolean to indicate the signature verification is passed or failed
```

spec folder has the necessary API example usage.

## Test Results

Refer to [test result](https://github.com/chrisliaw/liboqs-ruby/blob/master/TEST-RESULT.md) for details.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
