FROM ubuntu:19.04

LABEL maintainer="Dimitri Vasdekis <dvasdekis@gmail.com>"

# Set Env vars
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Chicago


RUN apt-get update && apt-get install -y unzip xvfb libxtst6 libxrender1 libxi6 socat software-properties-common curl supervisor x11vnc tmpreaper python3-pip

# Setup IB TWS
RUN mkdir -p /opt/TWS
WORKDIR /opt/TWS
COPY ./ibgateway-stable-standalone-linux-9721x-x64.sh /opt/TWS/ibgateway-stable-standalone-linux-972-x64.sh
RUN chmod a+x /opt/TWS/ibgateway-stable-standalone-linux-972-x64.sh

# Install IBController
RUN mkdir -p /opt/IBController/ && mkdir -p /root/IBController/Logs
WORKDIR /opt/IBController/
COPY ./IBCLinux-3.8.2/  /opt/IBController/
RUN chmod -R u+x *.sh && chmod -R u+x scripts/*.sh

WORKDIR /

# Install TWS
RUN yes n | /opt/TWS/ibgateway-stable-standalone-linux-972-x64.sh
RUN rm /opt/TWS/ibgateway-stable-standalone-linux-972-x64.sh

ENV DISPLAY :0

# Below files copied during build to enable operation without volume mount
COPY ./ib/IBController.ini /root/IBController/IBController.ini
RUN mkdir -p /root/Jts_config/
COPY ./ib/jts.ini /root/Jts_config/jts.ini

# Overwrite vmoptions file
RUN rm -f /root/Jts/ibgateway/972/ibgateway.vmoptions
COPY ./ibgateway.vmoptions /root/Jts/ibgateway/972/ibgateway.vmoptions

# Install Python requirements
RUN pip3 install supervisor

COPY ./restart-docker-vm.py /root/restart-docker-vm.py

COPY ./supervisord.conf /root/supervisord.conf

CMD /usr/bin/supervisord -c /root/supervisord.conf
