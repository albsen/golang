FROM phusion/baseimage:0.9.10

# Set correct environment variables.
ENV HOME /root

# define env
ENV HOME /root
ENV GOPATH /root/go
ENV GOROOT /usr/local/go
ENV PATH $PATH:$GOPATH/bin:$GOROOT/bin

# create go workspace
RUN mkdir -p $GOPATH
RUN mkdir -p $GOPATH/bin
RUN mkdir -p $GOPATH/pkg
RUN mkdir -p $GOPATH/src

# execute apt required operation
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y build-essential mercurial git-core subversion wget curl zip vim ca-certificates 

# make go 1.2.2 from tarball
RUN wget --no-verbose https://storage.googleapis.com/golang/go1.3.1.src.tar.gz
RUN echo "bc296c9c305bacfbd7bff9e1b54f6f66ae421e6e *go1.3.1.src.tar.gz" | sha1sum -c -
RUN tar -v -C /usr/local -xzf go1.3.1.src.tar.gz
RUN cd /usr/local/go/src && ./make.bash --no-clean 2>&1
RUN rm go1.3.1.src.tar.gz

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
