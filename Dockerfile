# Minimal Docker image for ViReflow using Ubuntu base
FROM ubuntu:20.04
MAINTAINER Niema Moshiri <niemamoshiri@gmail.com>

# install dependencies
RUN apt-get update && apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y autoconf cmake g++ git libbz2-dev libcurl4-openssl-dev liblzma-dev libtool make pkg-config python3 python3-pip unzip wget yasm zip zlib1g-dev && \
    ln -s $(which python3) /usr/local/bin/python && \

    # install htslib v1.12
    wget -qO- "https://github.com/samtools/htslib/releases/download/1.12/htslib-1.12.tar.bz2" | tar -xj && \
    cd htslib-* && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf htslib-* && \

    # install bcftools v1.12
    wget -qO- "https://github.com/samtools/bcftools/releases/download/1.12/bcftools-1.12.tar.bz2" | tar -xj && \
    cd bcftools-* && \
    ./configure --without-curses && \
    make && \
    make install && \
    cd .. && \
    wget -O /usr/local/bin/alt_vars.py "https://raw.githubusercontent.com/Niema-Docker/bcftools/1.12_1.0/alt_vars.py" && \
    chmod a+x /usr/local/bin/alt_vars.py && \
    rm -rf bcftools-* && \

    # install bedtools v2.30.0
    wget -qO- "https://github.com/arq5x/bedtools2/releases/download/v2.30.0/bedtools-2.30.0.tar.gz" | tar -zx && \
    cd bedtools2 && \
    make && \
    make install && \
    cd .. && \
    rm -rf bedtools2 && \

    # install Bowtie2 v2.4.3
    wget "https://github.com/BenLangmead/bowtie2/releases/download/v2.4.3/bowtie2-2.4.3-source.zip" && \
    unzip bowtie2-*-source.zip && \
    cd bowtie2-2.4.3 && \
    make && \
    make install && \
    cd .. && \
    rm -rf bowtie2-* && \

    # install BWA v0.7.17
    wget -qO- "https://github.com/lh3/bwa/releases/download/v0.7.17/bwa-0.7.17.tar.bz2" | tar -jx && \
    cd bwa-* && \
    make && \
    mv bwa /usr/local/bin/bwa && \
    cd .. && \
    rm -rf bwa-* && \

    # install Cutadapt v3.4
    wget -qO- "https://github.com/intel/isa-l/archive/refs/tags/v2.30.0.tar.gz" | tar -zx && \
    cd isa-l-* && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    pip3 install --no-cache-dir 'cutadapt==3.4' && \
    rm -rf isa-l-* && \

    # install fastp v0.20.1
    wget -qO- "https://github.com/OpenGene/fastp/archive/refs/tags/v0.20.1.tar.gz" | tar -zx && \
    cd fastp-* && \
    make && \
    make install && \
    cd .. && \
    rm -rf fastp-* && \

    # install freebayes v1.3.5
    git clone --recursive https://github.com/vcflib/vcflib.git --branch v1.0.2 && \
    mkdir -p vcflib/build && \
    cd vcflib/build && \
    git clone --recursive https://github.com/ekg/tabixpp.git --branch v1.1.0 && \
    cd tabixpp && \
    make && \
    gcc tabix.o -shared -o libtabixpp.so && \
    mkdir -p /usr/local/lib && \
    install -p -m 644 libtabixpp.so /usr/local/lib/ && \
    mkdir -p /usr/local/include && \
    install -p -m 644 tabix.hpp /usr/local/include/ && \
    cd htslib && \
    make && \
    make install && \
    cd ../.. && \
    cmake .. && \
    cmake --build . && \
    cmake --install . && \
    cd ../.. && \
    git clone --recursive https://github.com/freebayes/freebayes.git --branch v1.3.5 && \
    cd freebayes && \
    sed -i 7,17d src/SegfaultHandler.cpp && \
    sed -i 's/__off64_t/off64_t/g' src/LargeFileSupport.h && \
    sed -i 's/__off64_t/off64_t/g' vcflib/fastahack/LargeFileSupport.h && \
    meson build && \
    cd build && \
    ninja && \
    mv bamleftalign freebayes /usr/local/bin/ && \
    cd ../.. && \
    rm -rf freebayes vcflib && \

    # install iVar v1.3.1
    wget -qO- "https://github.com/andersen-lab/ivar/archive/refs/tags/v1.3.1.tar.gz" | tar -zx && \
    cd ivar-* && \
    sh autogen.sh && \
    ./configure --disable-dependency-tracking && \
    make && \
    make install && \
    cd .. && \
    wget -O /usr/local/bin/ivar_variants_to_vcf.py "https://raw.githubusercontent.com/Niema-Docker/ivar/main/ivar_variants_to_vcf.py" && \
    chmod a+x /usr/local/bin/ivar_variants_to_vcf.py && \
    rm -rf ivar-* && \

    # install LoFreq v2.1.5
    wget -qO- "https://github.com/CSB5/lofreq/raw/master/dist/lofreq_star-2.1.5.tar.gz" | tar -zx && \
    cd lofreq_star-* && \
    ./configure --with-htslib=/usr/local && \
    make && \
    make install && \
    cd .. && \
    rm -rf lofreq_star-* && \

    # install low_depth_regions
    wget "https://raw.githubusercontent.com/Niema-Docker/low_depth_regions/main/low_depth_regions.cpp" && \
    g++ -O3 -o /usr/local/bin/low_depth_regions low_depth_regions.cpp && \
    rm low_depth_regions.cpp && \

    # install Minimap2 v2.21
    wget -qO- "https://github.com/lh3/minimap2/archive/refs/tags/v2.21.tar.gz" | tar -zx && \
    cd minimap2-* && \
    make && \
    chmod a+x minimap2 && \
    mv minimap2 /usr/local/bin/minimap2 && \
    cd .. && \
    rm -rf minimap2-* && \

    # install Pangolin v3.1.7
    pip3 install --no-cache-dir 'wheel' && \
    pip3 install --no-cache-dir 'biopython' 'joblib' 'PuLP' 'pysam' 'snakemake' && \
    pip3 install --no-cache-dir 'git+https://github.com/cov-lineages/scorpio.git' && \
    pip3 install --no-cache-dir 'git+https://github.com/cov-lineages/constellations.git' && \
    pip3 install --no-cache-dir 'git+https://github.com/cov-lineages/pango-designation.git' && \
    pip3 install --no-cache-dir 'git+https://github.com/cov-lineages/pangoLEARN.git' && \
    wget -qO- "https://github.com/cov-ert/gofasta/archive/refs/tags/v0.0.5.tar.gz" | tar -zx && \
    cd gofasta-* && \
    go build && \
    mv gofasta /usr/local/bin/gofasta && \
    cd .. && \
    mkdir coinbrew && \
    cd coinbrew && \
    wget "https://raw.githubusercontent.com/coin-or/coinbrew/master/coinbrew" && \
    chmod a+x coinbrew && \
    ./coinbrew fetch Cbc@master && \
    (./coinbrew build Cbc --tests none --prefix=/usr/local || true) && \
    cd .. && \
    rm /usr/lib/python3.8/site-packages/pulp/apis/../solverdir/cbc/linux/64/cbc && \
    ln -s $(which cbc) /usr/lib/python3.8/site-packages/pulp/apis/../solverdir/cbc/linux/64/cbc && \
    pip3 install --no-cache-dir 'git+https://github.com/cov-lineages/pangolin.git@v3.1.7' && \
    # disable UShER check (for now)
    sed -i 's/,"usher"]/]#,"usher"]/g' /usr/lib/python3.8/site-packages/pangolin/utils/dependency_checks.py && \
    rm -rf coinbrew gofasta-* && \

    # install pi_from_pileup
    wget "https://raw.githubusercontent.com/Niema-Docker/pi_from_pileup/main/pi_from_pileup.cpp" && \
    g++ -O3 -o /usr/local/bin/pi_from_pileup pi_from_pileup.cpp && \
    rm pi_from_pileup.cpp && \

    # install PRINSEQ v0.20.4
    wget -qO- "http://iweb.dl.sourceforge.net/project/prinseq/standalone/prinseq-lite-0.20.4.tar.gz" | tar -zx && \
    chmod a+x prinseq-lite-*/*.pl && \
    mv prinseq-lite-*/*.pl /usr/local/bin/ && \
    rm -rf prinseq-lite-* && \

    # install pTrimmer v1.3.4
    pip3 install --no-cache-dir 'pyfaidx==0.5.9.5' && \
    wget -qO- "https://github.com/DMU-lilab/pTrimmer/archive/refs/tags/V1.3.4.tar.gz" | tar -zx && \
    cd pTrimmer-* && \
    make && \
    mv pTrimmer-* /usr/local/bin/pTrimmer && \
    cd .. && \
    # Bed2Amplicon.py isn't in the release tarball yet, but in a future pTrimmer release, it should be, so use version from there in the future
    wget -O /usr/local/bin/Bed2Amplicon.py "https://raw.githubusercontent.com/DMU-lilab/pTrimmer/master/Test/Bed2Amplicon.py" && \
    chmod a+x /usr/local/bin/Bed2Amplicon.py && \
    rm -rf pTrimmer-* && \

    # install samhead v1.0.0
    wget -qO- "https://github.com/niemasd/samhead/archive/refs/tags/1.0.0.tar.gz" | tar -zx && \
    cd samhead-* && \
    g++ -Wall -pedantic -O3 -std=c++11 -o /usr/local/bin/samhead samhead.cpp && \
    cd .. && \
    rm -rf samhead-* && \

    # install samtools v1.12
    wget -qO- "https://github.com/samtools/samtools/releases/download/1.12/samtools-1.12.tar.bz2" | tar -xj && \
    cd samtools-* && \
    ./configure --without-curses && \
    make && \
    make install && \
    cd .. && \
    rm -rf samtools-* && \
    
    # install SPAdes v3.15.2
    wget -qO- "https://github.com/ablab/spades/releases/download/v3.15.2/SPAdes-3.15.2.tar.gz" | tar -zx && \
    cd SPAdes-* && \
    # Alpine needs <stdint.h> to be included to have int32_t defined. I made a pull request to SPAdes, so remove this in the future
    sed -i '1i#include <stdint.h>' ext/src/bamtools/api/internal/io/pbgzf/util.c && \
    sed -i 's/#include "k_range.hpp"/#include <cstdint>\n#include "k_range.hpp"/g' src/common/sequence/seq_common.hpp && \
    # u_int64_t is not standard, but uint64_t is
    sed -i 's/u_int64_t/uint64_t/g' src/common/sequence/seq_common.hpp && \
    # Alpine strerror_r is messed up (https://stackoverflow.com/questions/41953104/strerror-r-is-incorrectly-declared-on-alpine-linux)
    sed -i 's/message = strerror_r(error_code, buffer, buffer_size)/message = buffer/g' ext/src/cppformat/format.cc && \
    # Alpine clib doesn't have backtrace (https://discuss.pytorch.org/t/compiling-master-from-source-on-alpine-fails-with-undefined-reference-to-backtrace/64676)
    sed -i 's/#include <execinfo.h>/\/\/#include <execinfo.h>/g' src/common/utils/stacktrace.hpp && \
    sed -i 's/print_stacktrace() {/print_stacktrace() {\/*/g' src/common/utils/stacktrace.hpp && \
    sed -i 's/free(func_names);/free(func_names);*\//g' src/common/utils/stacktrace.hpp && \
    PREFIX=/usr/local ./spades_compile.sh && \
    cd .. && \
    rm -rf SPAdes-* && \

    # clean up
    rm -rf ~/.cache /tmp/*
