FROM golang:1.21.3

RUN apt-get update && apt-get install -y \
  less \
  vim \
  curl \
  sudo

WORKDIR /app

CMD ["go", "run", "server.go"]
