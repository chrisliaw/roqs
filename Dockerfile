
FROM --platform=linux/x86_64 ubuntu:jammy

RUN apt-get update && apt-get install -y git curl build-essential software-properties-common gnupg2

RUN apt-add-repository -y ppa:rael-gc/rvm && apt-get update && apt-get install -y rvm
RUN /bin/bash -l -c ". /usr/share/rvm/scripts/rvm && rvm install ruby-3.2.1"

WORKDIR /opt

CMD ["/bin/bash","--login"]
