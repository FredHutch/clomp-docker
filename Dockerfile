
# build me as fredhutch/clomp

# an attempt at dockerizing https://github.com/vpeddu/CLOMP


FROM ubuntu:18.04

# install basic dpes
RUN apt-get update -y && apt-get install -y python3 python3-pip default-jre libz-dev samtools curl unzip git

# install Trimmomatic
RUN curl -LO http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip

RUN unzip Trimmomatic-0.39.zip

RUN rm Trimmomatic-0.39.zip

# download CLOMP repo
RUN git clone https://github.com/vpeddu/CLOMP.git

COPY adapters.fa /Trimmomatic-0.39/adapters/

# TODO FIXME (where it says ???)
RUN sed -i.bak  -e 's@/tools/Trimmomatic-0.38/trimmomatic-0.38.jar@/Trimmomatic-0.39/trimmomatic-0.39.jar@' -e 's@/tools/Trimmomatic-0.38/adapters/adapters.fa@/Trimmomatic-0.39/adapters/adapters.fa@'   CLOMP/CLOMP.ini

# install bowtie2
RUN curl -L https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.4.3/bowtie2-2.3.4.3-linux-x86_64.zip/download > bowtie2-2.3.4.3.zip

RUN unzip bowtie2-2.3.4.3.zip

ENV PATH="/bowtie2-2.3.4.3-linux-x86_64:${PATH}"

RUN rm bowtie2-2.3.4.3.zip

# install pyfasta
RUN pip3 install pyfasta

# install custom build of snap
RUN git clone https://github.com/rcs333/snap.git

WORKDIR /snap

RUN make

WORKDIR /

ENV PATH=/snap/apps:${PATH}

# TODO: install KrakenUniq?

# big data files should not go in this docker image, but instead should be placed on an EBS volume

