FROM debian:stretch

RUN apt-get update && apt-get install -y wget vim git tar unzip autoconf libtool automake zlibc pkg-config

RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list
RUN echo "deb http://deb.debian.org/debian stretch-backports-sloppy main" >> /etc/apt/sources.list

RUN apt-get -t stretch-backports-sloppy install -y libarchive13
RUN apt-get -t stretch-backports install -y gcc g++ cmake ninja-build lcov doxygen

RUN mkdir -p /ed247/dependencies
RUN mkdir -p /ed247/configuration

# LIBXML2
RUN cd /ed247/dependencies && wget https://github.com/GNOME/libxml2/archive/v2.9.9.zip && unzip v2.9.9.zip
RUN cd /ed247/dependencies/libxml2-2.9.9 && ./autogen.sh && make && make install

# Google Test
RUN cd /ed247/dependencies && wget -v https://github.com/google/googletest/archive/release-1.8.1.zip && unzip release-1.8.1.zip
RUN cd /ed247/dependencies/googletest-release-1.8.1/ && cmake . && make && make install

# Configuration
RUN git clone https://github.com/airbus/ED247_LIBRARY.git /ed247/library
ADD dependencies.sh.debian /ed247/configuration/dependencies.sh

WORKDIR /ed247/library
RUN chmod +x mgr.sh

CMD [ "./mgr.sh", "build", "-d", "/ed247/configuration/dependencies.sh", "gcc4.8.5", "x64" ]

