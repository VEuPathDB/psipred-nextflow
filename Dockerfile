FROM ubuntu:22.04
MAINTAINER rdemko2332@gmail.com
WORKDIR /work
RUN apt-get -qq update --fix-missing
RUN apt-get install -y wget cmake gcc perl tcsh
Run cd /usr/local/share  &&  wget http://bioinfadmin.cs.ucl.ac.uk/downloads/psipred/old_versions/psipred3.5.tar.gz  && tar -zxvf psipred3.5.tar.gz  && cd psipred/src   && make   && make install   && rm /usr/local/share/psipred3.5.tar.gz  && cd /usr/local/share && wget ftp://ftp.ncbi.nih.gov/blast/executables/legacy.NOTSUPPORTED/2.2.26/blast-2.2.26-x64-linux.tar.gz &&  tar -zxvf blast-2.2.26-x64-linux.tar.gz  && rm /usr/local/share/blast-2.2.26-x64-linux.tar.gz  &&  cd psipred  &&  rm runpsipred_single
COPY runpsipred_single /usr/local/share/psipred/
RUN cd /usr/local/share/psipred &&  chmod +x runpsipred_single
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/share/blast-2.2.26/bin:/usr/local/share/psipred/bin:/usr/local/share/psipred/:/usr/local/share/psipred/data:/usr/local/share/psipred/BLAST+:/usr/local/share/psipred/src
RUN  cd /work  &&  ln -s /usr/local/share/psipred/bin/ bin  &&  ln -s /usr/local/share/psipred/BLAST+/  &&   ln -s /usr/local/share/psipred/src/ src  &&  ln -s /usr/local/share/psipred/data/ data  
WORKDIR /work



