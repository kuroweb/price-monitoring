FROM mcr.microsoft.com/playwright:v1.53.0-jammy

WORKDIR /root
RUN npm install playwright@1.53.0

CMD ["./node_modules/.bin/playwright", "run-server", "--port", "8888", "--path", "/ws", "--host", "0.0.0.0"]
