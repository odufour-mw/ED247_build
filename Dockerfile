FROM debian:jessie

RUN apt-get update && apt-get install -y wget vim git tar unzip bzip2 autoconf libtool automake zlibc pkg-config libarchive13

#
# GCC (v4.8.4)
# Lcov (v1.13)
# Doxygen (v1.8.13)
#
RUN apt-get install -y gcc-4.8 g++-4.8 lcov doxygen make
RUN rm /usr/bin/gcc && ln -s /usr/bin/gcc-4.8 /usr/bin/gcc && ln -s /usr/bin/g++-4.8 /usr/bin/g++

RUN mkdir -p /ed247/dependencies
RUN mkdir -p /ed247/configuration

# CMake (v3.13.4)
RUN cd /ed247/dependencies && wget https://github.com/Kitware/CMake/releases/download/v3.13.4/cmake-3.13.4-Linux-x86_64.sh && chmod +x cmake-3.13.4-Linux-x86_64.sh
RUN cd /ed247/dependencies && mkdir cmake && ./cmake-3.13.4-Linux-x86_64.sh --skip-license --prefix=/ed247/dependencies/cmake && ln -s /ed247/dependencies/cmake/bin/cmake /usr/bin/cmake

# Ninja (v1.8.2)
RUN cd /ed247/dependencies && wget https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip && unzip ninja-linux.zip
RUN cp /ed247/dependencies/ninja /usr/bin/ninja

# LIBXML2 (v2.9.9)
RUN cd /ed247/dependencies && wget https://github.com/GNOME/libxml2/archive/v2.9.9.zip && unzip v2.9.9.zip
RUN cd /ed247/dependencies/libxml2-2.9.9 && ./autogen.sh && make && make install

# Google Test (v1.8.1)
RUN cd /ed247/dependencies && wget -v https://github.com/google/googletest/archive/release-1.8.1.zip && unzip release-1.8.1.zip
RUN cd /ed247/dependencies/googletest-release-1.8.1/ && cmake . && make && make install

# Configuration
RUN git clone https://github.com/airbus/ED247_LIBRARY.git /ed247/library
ADD dependencies.sh.debian /ed247/configuration/dependencies.sh

WORKDIR /ed247/library
RUN chmod +x mgr.sh

CMD [ "./mgr.sh", "build", "-d", "/ed247/configuration/dependencies.sh", "gcc4.8.5", "x64" ]

