FROM phusion/baseimage:0.9.17
MAINTAINER Oswaldo Dantas "oswaldodantas@gmail.com"

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer libxext-dev libxrender-dev libxtst-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# Install libgtk as a separate step so that we can share the layer above with
# the netbeans image
RUN apt-get update && apt-get install -y libgtk2.0-0 libcanberra-gtk-module

RUN wget http://ftp.fau.de/eclipse/technology/epp/downloads/release/mars/1/eclipse-java-mars-1-linux-gtk-x86_64.tar.gz -O /tmp/eclipse.tar.gz -q && \
    echo 'Installing eclipse' && \
    tar -xf /tmp/eclipse.tar.gz -C /opt && \
    rm /tmp/eclipse.tar.gz

# Install Scala IDE
RUN cd /opt/eclipse && ./eclipse \
    -clean -purgeHistory \
    -application org.eclipse.equinox.p2.director \
    -noSplash \
    -repository \
http://download.eclipse.org/releases/juno,\
http://download.scala-ide.org/sdk/lithium/e44/scala211/stable/site\
    -installIUs \
org.scala-ide.sdt.feature.feature.group,\
org.scala-ide.scala211.feature.feature.group,\
org.scala-ide.scala211.source.feature.feature.group,\
org.scala-ide.sbt.feature.feature.group,\
org.scala-ide.play2.feature.feature.group,\
org.scala.tools.eclipse.search.feature.feature.group,\
org.scalaide.worksheet.feature.feature.group,\
org.scala-ide.sdt.scalatest.feature.feature.group

ADD run /usr/local/bin/eclipse

RUN chmod +x /usr/local/bin/eclipse && \
    mkdir -p /home/developer && \
    echo "developer:x:`id -u`:`id -g`:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:`id -u`:" >> /etc/group && \
    mkdir -p /etc/sudoers.d && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer

USER developer
ENV HOME /home/developer
WORKDIR /home/developer
CMD /usr/local/bin/eclipse

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
