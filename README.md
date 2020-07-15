# Interactive Brokers Gateway Docker for GCP

This repo takes mvberg's work and optimises it for GCP (targeting a e2-small instance):

* Ubuntu 20.04 (Default of 16.04 isn't docker optimised)
* Changed to TWS Gateway stable (v972.1v)
* Removed installers after they are no longer used
* Works with Stackdriver logging
* Optimisation of the Java runtime options
* VNC scripting (which didn't restart the container on error) fixed via Supervisor


IB Gateway running in Docker with [IBC, successor of IB Controller](https://github.com/IbcAlpha/IBC) and VNC

* TWS Gateway: v978.2c (Current Stable)
* IB Controller: v3.8.2

### Docker Hub image

* [dvasdekis/ib-gateway-docker](https://hub.docker.com/r/dvasdekis/ib-gateway-docker)

### Getting Started

`gcloud compute instances create-with-container my-ib-gateway --container-image="docker.io/dvasdekis/ib-gateway-docker:v978" --container-env-file="./ibgateway.env" --machine-type=e2-small --container-env TWSUSERID="$tws_user_id",TWSPASSWORD="$tws_password",TRADING_MODE=paper --zone="my-preferred-zone"`

#### Expected output

Visible in StackDriver:
```
Creating ibgatewaydocker_tws_1 ...
Creating ibgatewaydocker_tws_1 ... done
Attaching to ibgatewaydocker_tws_1
tws_1  | Starting virtual X frame buffer: Xvfb.
tws_1  | find: '/opt/IBController/Logs': No such file or directory
tws_1  | stored passwd in file: /.vnc/passwd
tws_1  | Starting x11vnc.
tws_1  |
tws_1  | +==============================================================================
tws_1  | +
tws_1  | + IBController version 3.2.0.5
tws_1  | +
tws_1  | + Running GATEWAY 978
tws_1  | +
tws_1  | + Diagnostic information is logged in:
tws_1  | +
tws_1  | + /opt/IBController/Logs/ibc-3.2.0.5_GATEWAY-960_Tuesday.txt
tws_1  | +
tws_1  | +
tws_1  | Forking :::4001 onto 0.0.0.0:4003\n
```

You will now have the IB Gateway app running on port 4003.

See [docker-compose.yml](docker-compose.yml) for configuring VNC password, accounts and trading mode.

Please do not open your box to the internet.


### Troubleshooting

Sometimes, when running in non-daemon mode, you will see this:

```java
Exception in thread "main" java.awt.AWTError: Can't connect to X11 window server using ':0' as the value of the DISPLAY variable.
```

You will have to remove the container `docker rm container_id` and run `docker-compose up` again.
