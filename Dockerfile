FROM ubuntu:22.04
MAINTAINER rdemko2332@gmail.com
WORKDIR /work
RUN apt-get -qq update --fix-missing
RUN apt-get install -y wget cmake gcc perl tcsh
Run cd /usr/local/share  &&  wget http://bioinfadmin.cs.ucl.ac.uk/downloads/psipred/old_versions/psipred.4.0.tar.gz  && tar -zxvf psipred.4.0.tar.gz  && cd psipred/src  && make  && make install  && rm /usr/local/share/psipred.4.0.tar.gz  && cd /usr/local/share  && wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.13.0+-x64-linux.tar.gz && tar -zxvf ncbi-blast-2.13.0+-x64-linux.tar.gz && rm -rf ncbi-blast-2.13.0+-x64-linux.tar.gz  &&  cd psipred  &&  rm runpsipred_single
COPY bin/runpsipred_single /usr/local/share/psipred/
RUN cd /usr/local/share/psipred  &&  chmod +x runpsipred_single
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/share/ncbi-blast-2.13.0+/bin:/usr/local/share/psipred/bin:/usr/local/share/psipred/:/usr/local/share/psipred/data:/usr/local/share/psipred/BLAST+:/usr/local/share/psipred/src
RUN  cd /work  &&  ln -s /usr/local/share/psipred/bin/ bin  &&  ln -s /usr/local/share/psipred/BLAST+/  &&  ln -s /usr/local/share/psipred/src/ src  &&  ln -s /usr/local/share/psipred/data/ data  
WORKDIR /work



