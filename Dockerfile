# Minimal Docker image for ViReflow using Ubuntu base
FROM ubuntu:20.04
MAINTAINER Niema Moshiri <niemamoshiri@gmail.com>

# install dependencies
RUN apt-get -qq update && apt-get -qq -y upgrade && \
    apt-get -qq install -y autoconf g++ g++-10 git libbz2-dev libcurl4-openssl-dev liblzma-dev libtool make pigz python3 python3-pip wget unzip yasm zlib1g-dev && \
    ln -s $(which python3) /usr/local/bin/python && \

    # install htslib v1.14
    wget -qO- "https://github.com/samtools/htslib/releases/download/1.14/htslib-1.14.tar.bz2" | tar -xj && \
    cd htslib-* && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf htslib-* && \

    # install bcftools v1.14
    wget -qO- "https://github.com/samtools/bcftools/releases/download/1.14/bcftools-1.14.tar.bz2" | tar -xj && \
    cd bcftools-* && \
    ./configure --without-curses && \
    make && \
    make install && \
    cd .. && \
    wget -O /usr/local/bin/alt_vars.py "https://github.com/Niema-Docker/bcftools/raw/main/alt_vars.py" && \
    chmod a+x /usr/local/bin/alt_vars.py && \
    rm -rf bcftools-* && \

    # install bedtools v2.30.0
    wget -q -O /usr/local/bin/bedtools "https://github.com/arq5x/bedtools2/releases/download/v2.30.0/bedtools.static.binary" && \
    chmod a+x /usr/local/bin/bedtools && \

    # install BLAST+ v2.13.0
    wget -qO- "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.13.0/ncbi-blast-2.13.0+-x64-linux.tar.gz" | tar -zx && \
    mv ncbi-blast-*/bin/* /usr/local/bin/ && \
    rm -rf ncbi-blast-* && \

    # install Bowtie2 v2.4.5
    wget -q "https://github.com/BenLangmead/bowtie2/releases/download/v2.4.5/bowtie2-2.4.5-linux-x86_64.zip" && \
    unzip bowtie2-*.zip && \
    mv bowtie2-*/bowtie2* /usr/local/bin/ && \
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

    # install fastp v0.23.2
    wget -q -O /usr/local/bin/fastp "http://opengene.org/fastp/fastp.0.23.2" && \
    chmod a+x /usr/local/bin/fastp && \

    # install freebayes v1.3.6
    wget -qO- "https://github.com/freebayes/freebayes/releases/download/v1.3.6/freebayes-1.3.6-linux-amd64-static.gz" | gunzip > /usr/local/bin/freebayes && \
    chmod a+x /usr/local/bin/freebayes && \

    # install HISAT2 v2.2.1
    wget -q -O hisat2.zip "https://cloud.biohpc.swmed.edu/index.php/s/oTtGWbWjaxsQ2Ho/download" && \
    unzip hisat2.zip && \
    mv hisat2-*/extract* hisat2-*/hisat2* hisat2-*/scripts /usr/local/bin/ && \
    rm -rf hisat2* && \

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

    # install MEGAHIT v1.2.9
    wget -qO- "https://github.com/voutcn/megahit/releases/download/v1.2.9/MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz" | tar -zx && \
    mv MEGAHIT-*/bin/* /usr/local/bin/ && \
    mv MEGAHIT-*/share/* /usr/local/share/ && \
    rm -rf MEGAHIT-* && \

    # install minia v0.0.102
    wget -qO- "https://github.com/GATB/minia/releases/download/v0.0.102/minia-v0.0.102-bin-Linux.tar.gz" | tar -zx && \
    mv minia-*/bin/* /usr/local/bin/ && \
    mv minia-*/lib/libhdf5.settings /usr/local/lib/ && \
    mkdir -p /usr/local/lib/pkgconfig && \
    mv minia-*/lib/pkgconfig/* /usr/local/lib/pkgconfig/ && \
    rm -rf minia-* && \

    # install Minimap2 v2.24
    wget -qO- "https://github.com/lh3/minimap2/releases/download/v2.24/minimap2-2.24_x64-linux.tar.bz2" | tar -xj && \
    mv minimap2-*/minimap2 /usr/local/bin/minimap2 && \
    rm -rf minimap2-* && \

    # install Pangolin v3.1.7
    wget -q -O /usr/local/bin/gofasta "https://github.com/virus-evolution/gofasta/releases/download/v1.0.0/gofasta-linux-amd64" && \
    chmod a+x /usr/local/bin/gofasta && \
    pip3 install --no-cache-dir 'biopython' 'joblib' 'PuLP' 'pysam' 'snakemake' && \
    pip3 install --no-cache-dir 'git+https://github.com/cov-lineages/scorpio.git' && \
    pip3 install --no-cache-dir 'git+https://github.com/cov-lineages/constellations.git' && \
    pip3 install --no-cache-dir 'git+https://github.com/cov-lineages/pango-designation.git' && \
    pip3 install --no-cache-dir 'git+https://github.com/cov-lineages/pangoLEARN.git' && \
    pip3 install --no-cache-dir 'git+https://github.com/cov-lineages/pangolin.git@v3.1.7' && \
    # disable UShER check (for now)
    sed -i 's/,"usher"]/]#,"usher"]/g' /usr/local/lib/python3.8/dist-packages/pangolin/utils/dependency_checks.py && \
    rm -rf gofasta-* && \

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

    # install samtools v1.14
    wget -qO- "https://github.com/samtools/samtools/releases/download/1.14/samtools-1.14.tar.bz2" | tar -xj && \
    cd samtools-* && \
    ./configure --without-curses && \
    make && \
    make install && \
    cd .. && \
    rm -rf samtools-* && \
    
    # install SPAdes v3.15.3
    wget -qO- "https://github.com/ablab/spades/releases/download/v3.15.3/SPAdes-3.15.3-Linux.tar.gz" | tar -zx && \
    mv SPAdes-*/bin/* /usr/local/bin/ && \
    mv SPAdes-*/share/* /usr/local/share/ && \
    rm -rf SPAdes-* && \

    # install Unicycler v0.5.0
    wget -qO- "https://github.com/rrwick/Unicycler/archive/refs/tags/v0.5.0.tar.gz" | tar -zx && \
    cd Unicycler-* && \
    python3 setup.py install --makeargs "CXX=g++-10" && \
    cd .. && \
    rm -rf Unicycler-* && \

    # install VirStrain v1.10
    pip3 install --no-cache-dir 'virstrain==1.10' && \
    mkdir -p /usr/lib/python3/dist-packages/ && \
    ln -s /usr/local/lib/python3.8/dist-packages/VirStrain /usr/lib/python3/dist-packages/VirStrain && \
    wget -qO- "https://figshare.com/ndownloader/files/34002479" | tar -zx && \
    mv VirStrain_DB /usr/local/bin/VirStrain_DB && \

    # clean up
    rm -rf ~/.cache /tmp/*

ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH
