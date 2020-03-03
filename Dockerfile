FROM ubuntu:19.04

LABEL maintainer="Dimitri Vasdekis <dvasdekis@gmail.com>"

RUN apt-get update && apt-get install -y unzip xvfb libxtst6 libxrender1 libxi6 socat software-properties-common curl supervisor x11vnc tmpreaper

# Setup IB TWS
RUN mkdir -p /opt/TWS
WORKDIR /opt/TWS
COPY ./ibgateway-stable-standalone-linux-972-x64.sh /opt/TWS/ibgateway-stable-standalone-linux-972-x64.sh
RUN chmod a+x /opt/TWS/ibgateway-stable-standalone-linux-972-x64.sh

# Setup  IBController
RUN mkdir -p /opt/IBController/ && mkdir -p /root/IBController/Logs
WORKDIR /opt/IBController/
COPY ./IBController-QuantConnect-3.2.0.5.zip  /opt/IBController/IBController-QuantConnect-3.2.0.5.zip
RUN unzip ./IBController-QuantConnect-3.2.0.5.zip
RUN chmod -R u+x *.sh && chmod -R u+x Scripts/*.sh
RUN rm ./IBController-QuantConnect-3.2.0.5.zip

WORKDIR /

# Install TWS
RUN yes n | /opt/TWS/ibgateway-stable-standalone-linux-972-x64.sh
RUN rm /opt/TWS/ibgateway-stable-standalone-linux-972-x64.sh

ENV DISPLAY :0

# Below files copied during build to enable operation without volume mount
COPY ./ib/IBController.ini /root/IBController/IBController.ini
COPY ./ib/jts.ini /root/Jts/jts.ini

# Overwrite vmoptions file
RUN rm -f /root/Jts/ibgateway/972/ibgateway.vmoptions
COPY ./ibgateway.vmoptions /root/Jts/ibgateway/972/ibgateway.vmoptions

COPY ./restart-docker-vm.sh /root/restart-docker-vm.sh
RUN chmod a+x /root/restart-docker-vm.sh

COPY ./supervisord.conf /root/supervisord.conf

CMD /usr/bin/supervisord -c /root/supervisord.conf
