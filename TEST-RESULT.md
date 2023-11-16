
# The following are test results for release roqs-0.1.0

liboqs-0.9.0 has less PQ algorithms and includes all 4 + 3 of the [finalist in the NIST PQC Standardization Candidates](https://csrc.nist.gov/news/2022/pqc-candidates-to-be-standardized-and-round-4)
## Development Environment

The source code was tested on 
* Linux:   Ruby MRI 3.2.1 (2023-02-08 revision 31819e82c8) [x86\_64-linux], Linux Mint 21.2 x86\_64, Kernel 5.15.0-88-generic, CMake version 3.22.1, Ninja 1.10.1

## Testing result

The following test result is by running the rspec.

The compiled liboqs version 0.9.0 library on Linux works flawlessly.

Unfornately I've lost access to MacOS. Any help would be gladely appreciated.

All KEM and SIG algos supported completed all major operations such as keygen, sign/verify, encap/decap without error.


### Windows (Coming Soon)

# The following are the test results for liboqs version 0.7.0 (before NIST finalist was published. It may not relevent for now just for history purposes)
## Development Environment

The source code was tested on 
* Linux: Ruby MRI 3.0.2p107 (2021-07-07 revision 0db68f0233) [x86_64-linux], Linux Mint 20.2 x86_64, Kernel 5.4.0-81-generic, Intel i7-9750H, CMake version 3.16.3, Ninja 1.10.0
* MacOS:   Ruby MRI 3.0.1p64 (2021-04-05 revision 0fb782ee38) [x86\_64-darwin20], Mac OS BigSur 11.5, 2.5GHz Quad-Core Intel Core i7, Apple clang version 12.0.5 (clang-1205.0.22.11), CMake version 3.21.1, Ninja 1.10.2
* Windows: Ruby MRI 3.0.2p107 (2021-07-07 revision 0db68f02333) [x64-mingw32], Windows 10 64 bits, Microsoft C/C++ compiler v 19.25.28610.4, Intel i7-9750H, CMake version 3.16.19112601-MSVC\_2, Ninja 1.8.2

## Testing result

The following test result is by running the rspec.

The compiled liboqs version 0.7.0 library on Linux works flawlessly on respective OS. 

All KEM and SIG algos supported completed all major operations such as keygen, sign/verify, encap/decap without error.


### Windows (Cross Compiling)

Cross compiling DLL for Windows on Linux with MingW toolchain failed with:
For KEM:
* BIKE-L1 & BIKE-L3 failed where library return null. Both running ok on Linux and MacOS
* Stack level too deep with all Classic-McEliece family of algo. All algo of Classic-McEliece-xxxx not able to execute.
* Stagmentation fault for SIDH-p503, SIDH-p503-compressed, SIDH-p751, SIDH-p751-compressed, SIKE-p503, SIKE-p751, SIKE-p503-compressed and SIKE-p751-compressed

For SIG:
* Stack level too deep for Rainbow-V-Classic, Rainbow-V-Circumzenithal and Rainbow-V-Compressed

Test cases not able to proceed after "Stack level too deep" exception. Not sure due to Ruby or native library

### Windows (Native build)

Native compile oqs library on Windows however have different result:
For KEM:
* BIKE-L1 & BIKE-L3 failed where library return null. Both running ok on Linux and MacOS
* Stack level too deep with all Classic-McEliece family of algo. All algo of Classic-McEliece-xxxx not able to execute.

For SIG
* Rainbow-V still crash

Rainbow feels taking longer time on Windows compare to Linux/Mac?
Sphincs slow too

But SIDH-xxx and SIKE-xxx family passed on native build


