FROM ubuntu:22.04

MAINTAINER rdemko2332@gmail.com

WORKDIR /usr/local/share

RUN apt-get -qq update --fix-missing

RUN apt-get install -y \
  wget \
  cmake \
  gcc \
  perl \
  tcsh

Run wget http://bioinfadmin.cs.ucl.ac.uk/downloads/psipred/old_versions/psipred.4.0.tar.gz  \
  && tar -zxvf psipred.4.0.tar.gz \
  && rm psipred.4.0.tar.gz \
  && cd psipred/src  \
  && make  \
  && make install \
  && rm ../runpsipred_single
  
Run wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.13.0+-x64-linux.tar.gz \
  && tar -zxvf ncbi-blast-2.13.0+-x64-linux.tar.gz \
  && rm ncbi-blast-2.13.0+-x64-linux.tar.gz 

COPY bin/runpsipred_single /usr/local/share/psipred/

RUN cd /usr/local/share/psipred  &&  chmod +x runpsipred_single

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/share/ncbi-blast-2.13.0+/bin:/usr/local/share/psipred/bin:/usr/local/share/psipred/:/usr/local/share/psipred/data:/usr/local/share/psipred/BLAST+:/usr/local/share/psipred/src

WORKDIR /work

RUN  ln -s /usr/local/share/psipred/bin/ \
  &&  ln -s /usr/local/share/psipred/BLAST+/  \
  &&  ln -s /usr/local/share/psipred/src/ \
  &&  ln -s /usr/local/share/psipred/data/  

WORKDIR /work



