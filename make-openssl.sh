mkdir /tmp/openssl \
  && cd /tmp/openssl \
  && curl -OJ https://github.com/openssl/openssl/releases/download/openssl-3.2.5/openssl-3.2.5.tar.gz \
  && tar -xzf openssl-3.2.5.tar.gz \
  && cd openssl-3.2.5 \
  && ./Configure \
  && make -j4

#  && make install \
#  && cd /tmp \
#  && rm -rf /tmp/openssl
