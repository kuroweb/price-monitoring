FROM debian:bullseye

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    tor \
 && rm -rf /var/lib/apt/lists

RUN useradd -m user
USER user

EXPOSE 9050/tcp

CMD ["tor", "--SocksPort", "0.0.0.0:9050"]
