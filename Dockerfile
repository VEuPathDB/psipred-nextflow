FROM ubuntu:22.04
MAINTAINER rdemko2332@gmail.com
WORKDIR /work
RUN apt-get -qq update --fix-missing
RUN apt-get install -y wget cmake gcc perl tcsh
Run wget http://bioinfadmin.cs.ucl.ac.uk/downloads/psipred/old_versions/psipred3.5.tar.gz  && tar -zxvf psipred3.5.tar.gz  && cd psipred/src   && make   && make install   && rm /work/psipred3.5.tar.gz  && cd /work && wget ftp://ftp.ncbi.nih.gov/blast/executables/legacy.NOTSUPPORTED/2.2.26/blast-2.2.26-x64-linux.tar.gz &&  tar -zxvf blast-2.2.26-x64-linux.tar.gz  && rm /work/blast-2.2.26-x64-linux.tar.gz
RUN cp /work/psipred/runpsipred_single /usr/bin  &&  cd /usr/bin  && chmod +x runpsipred_single  && cd /work/psipred
WORKDIR /work/psipred


