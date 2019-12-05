FROM ubuntu:19.04

LABEL maintainer="Mike Ehrenberg <mvberg@gmail.com>"

RUN  apt-get update \
  && apt-get install -y unzip xvfb libxtst6 libxrender1 libxi6 socat software-properties-common dos2unix curl


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

ADD runscript.sh runscript.sh
ADD ./vnc/xvfb_init /etc/init.d/xvfb
ADD ./vnc/vnc_init /etc/init.d/vnc
ADD ./vnc/xvfb-daemon-run /usr/bin/xvfb-daemon-run

RUN chmod -R u+x runscript.sh \
  && chmod -R 777 /usr/bin/xvfb-daemon-run \
  && chmod 777 /etc/init.d/xvfb \
  && chmod 777 /etc/init.d/vnc

RUN dos2unix /usr/bin/xvfb-daemon-run \
  && dos2unix /etc/init.d/xvfb \
  && dos2unix /etc/init.d/vnc \
  && dos2unix runscript.sh

# Below files copied during build to enable operation without volume mount
COPY ./ib/IBController.ini /root/IBController/IBController.ini
COPY ./ib/jts.ini /root/Jts/jts.ini

# Overwrite vmoptions file
RUN rm -f /root/Jts/ibgateway/972/ibgateway.vmoptions
COPY ./ibgateway.vmoptions /root/Jts/ibgateway/972/ibgateway.vmoptions

# Add stackdriver logging
curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
sudo bash install-logging-agent.sh

CMD bash runscript.sh
