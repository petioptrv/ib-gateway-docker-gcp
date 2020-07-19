
# This is the dockerfile for our Exch-Fetcher instance

# Shell can be run via docker run -it *hedgecheap1/mono_exc:tag*
FROM python:3

MAINTAINER Dimitri Vasdekis <dimitri@hedgecheap.com>

# Set Env vars
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Chicago

# Install any Python package requirements
COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt
COPY src/ /usr/bin

# Execute Supervisord as key - to ssh in, commend out the line below
CMD ["python","/usr/bin/src/run_tests.py"]
