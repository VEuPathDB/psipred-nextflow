FROM ubuntu:22.04

MAINTAINER rdemko2332@gmail.com

WORKDIR /usr/local/share

RUN apt-get -qq update --fix-missing

# Installing Software
RUN apt-get install -y \
  wget \
  cmake \
  gcc \
  perl \
  tcsh \
  bioperl  

# Install and set up of Psipred.
Run wget http://bioinfadmin.cs.ucl.ac.uk/downloads/psipred/old_versions/psipred.4.0.tar.gz  \
  && tar -zxvf psipred.4.0.tar.gz \
  && rm psipred.4.0.tar.gz \
  && cd psipred/src  \
  && make  \
  && make install \
  && rm ../runpsipred_single

# Replacing old with new runpsipred_single, so I could change set variables
COPY bin/runpsipred_single /usr/local/share/psipred/
COPY bin/removeSeqsOver10K /usr/bin/

# Making runpsipred_single executable
RUN cd /usr/local/share/psipred  &&  chmod +x runpsipred*
RUN cd /usr/bin/  &&  chmod +x removeSeqsOver10K

# Install and set up of ncbi blast toolkit
Run wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.14.1+-x64-linux.tar.gz  \
  && tar -zxvf ncbi-blast-2.14.1+-x64-linux.tar.gz  \
  && rm ncbi-blast-2.14.1+-x64-linux.tar.gz  

# Setting Path variable
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/share/ncbi-blast-2.13.0+/bin:/usr/local/share/psipred/bin:/usr/local/share/psipred/:/usr/local/share/psipred/data:/usr/local/share/psipred/BLAST+:/usr/local/share/psipred/src

WORKDIR /work

# Making simlinks in the work directory so the tool has access to needed software
RUN  ln -s /usr/local/share/psipred/bin/ \
  &&  ln -s /usr/local/share/psipred/BLAST+/  \
  &&  ln -s /usr/local/share/psipred/src/ \
  &&  ln -s /usr/local/share/psipred/data/  





