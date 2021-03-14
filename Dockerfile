FROM debian:buster

RUN apt-get update && apt-get install -y vim git wget unzip gnupg software-properties-common sudo
RUN useradd -ms /bin/bash kris
RUN adduser kris sudo
RUN wget -qO - 'https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public' | apt-key add -
RUN wget -qO - 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823' | apt-key add -
RUN add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-get update && apt-get install -y adoptopenjdk-8-hotspot sbt
RUN wget "https://downloads.lightbend.com/scala/2.12.13/scala-2.12.13.tgz" -P /home/kris
RUN cd /home/kris/ && tar -xvf scala-2.12.13.tgz
ENV SCALA_HOME=/home/kris/scala-2.12.13
ENV PATH=$PATH:$SCALA_HOME/bin
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER kris
WORKDIR /home/kris
ENV NVM_DIR /home/kris/.nvm
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash 
RUN . $NVM_DIR/nvm.sh \
    && nvm install --lts
RUN sudo mkdir /opt/ebiznes-app
RUN sudo chown -R kris:kris /opt/ebiznes-app
    
EXPOSE 9000 3000

VOLUME /opt/ebiznes-app
