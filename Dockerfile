FROM ubuntu:24.04

LABEL name="httpbin"
LABEL version="0.9.2"
LABEL description="A simple HTTP service."
LABEL org.kennethreitz.vendor="Kenneth Reitz"

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8


ADD requirements.txt /httpbin/
WORKDIR /httpbin

RUN apt update -y && apt install python3-pip git -y 
RUN apt install python3-venv -y
RUN python3 -m venv venv && . venv/bin/activate &&  venv/bin/pip install --no-cache-dir pipenv
RUN /bin/bash -c "venv/bin/pip install --no-cache-dir -r requirements.txt"

ADD . /httpbin
RUN venv/bin/pip install --no-cache-dir /httpbin

EXPOSE 80

CMD ["venv/bin/gunicorn", "-b", "0.0.0.0:80", "httpbin:app", "-k", "gevent"]
