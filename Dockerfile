# Minimal Docker image for ViReflow using Alpine base
FROM alpine:latest
MAINTAINER Niema Moshiri <niemamoshiri@gmail.com>

# install dependencies
RUN apk update && \
    apk add autoconf automake bash bzip2-dev gcc g++ make musl-dev perl python3 unzip xz-dev zlib-dev && \
    ln -s $(which python3) /usr/local/bin/python

# install htslib v1.12
RUN wget -qO- "https://github.com/samtools/htslib/releases/download/1.12/htslib-1.12.tar.bz2" | tar -xj && \
    cd htslib-1.12 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf htslib-1.12

# install bcftools v1.12
RUN wget -qO- "https://github.com/samtools/bcftools/releases/download/1.12/bcftools-1.12.tar.bz2" | tar -xj && \
    cd bcftools-1.12 && \
    ./configure --without-curses && \
    make && \
    make install && \
    cd .. && \
    rm -rf bcftools-1.12

# install bedtools v2.30.0
RUN wget -qO- "https://github.com/arq5x/bedtools2/releases/download/v2.30.0/bedtools-2.30.0.tar.gz" | tar -zx && \
    cd bedtools2 && \
    make && \
    make install && \
    cd .. && \
    rm -rf bedtools2

# install Bowtie2 v2.4.3
RUN wget "https://github.com/BenLangmead/bowtie2/releases/download/v2.4.3/bowtie2-2.4.3-source.zip" && \
    unzip bowtie2-2.4.3-source.zip && \
    cd bowtie2-2.4.3 && \
    make && \
    make install && \
    cd .. && \
    rm -rf bowtie2-2.4.3 bowtie2-2.4.3-source.zip

# install BWA v0.7.17
RUN wget -qO- "https://github.com/lh3/bwa/releases/download/v0.7.17/bwa-0.7.17.tar.bz2" | tar -jx && \
    cd bwa-0.7.17 && \
    sed -i 's/const uint8_t rle_auxtab\[8\];/\/\/const uint8_t rle_auxtab\[8\];/g' rle.h && \
    make && \
    mv bwa /usr/local/bin/bwa && \
    cd .. && \
    rm -rf bwa-0.7.17

# install iVar v1.3.1
RUN wget -qO- "https://github.com/andersen-lab/ivar/archive/refs/tags/v1.3.1.tar.gz" | tar -zx && \
    cd ivar-1.3.1 && \
    sh autogen.sh && \
    ./configure --disable-dependency-tracking && \
    make && \
    make install && \
    cd .. && \
    rm -rf ivar-1.3.1

# install LoFreq v2.1.5
RUN wget -qO- "https://github.com/CSB5/lofreq/raw/master/dist/lofreq_star-2.1.5.tar.gz" | tar -zx && \
    cd lofreq_star-2.1.5 && \
    ./configure --with-htslib=/usr/local && \
    make && \
    make install && \
    cd .. && \
    rm -rf lofreq_star-2.1.5

# install low_depth_regions
RUN wget "https://raw.githubusercontent.com/Niema-Docker/low_depth_regions/main/low_depth_regions.cpp" && \
    g++ -O3 -o /usr/local/bin/low_depth_regions low_depth_regions.cpp && \
    rm low_depth_regions.cpp

# install Minimap2 v2.17
RUN wget -qO- "https://github.com/lh3/minimap2/archive/refs/tags/v2.17.tar.gz" | tar -zx && \
    cd minimap2-2.17 && \
    make && \
    chmod a+x minimap2 && \
    mv minimap2 /usr/local/bin/minimap2 && \
    cd .. && \
    rm -rf minimap2-2.17

# install pi_from_pileup
RUN wget "https://raw.githubusercontent.com/Niema-Docker/pi_from_pileup/main/pi_from_pileup.cpp" && \
    g++ -O3 -o /usr/local/bin/pi_from_pileup pi_from_pileup.cpp && \
    rm pi_from_pileup.cpp

# install samtools v1.12
RUN wget -qO- "https://github.com/samtools/samtools/releases/download/1.12/samtools-1.12.tar.bz2" | tar -xj && \
    cd samtools-1.12 && \
    ./configure --without-curses && \
    make && \
    make install && \
    cd .. && \
    rm -rf samtools-1.12
