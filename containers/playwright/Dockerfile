FROM mcr.microsoft.com/playwright:v1.34.3-focal

WORKDIR /root
RUN npm install playwright@1.34.3 && ./node_modules/.bin/playwright install

CMD ["./node_modules/.bin/playwright", "run-server", "--port", "8888", "--path", "/ws"]
