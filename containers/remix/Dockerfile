FROM node:20

WORKDIR /app

# node_modules
COPY volumes/remix/package.json .
COPY volumes/remix/package-lock.json .
RUN npm i

CMD ["npm", "run", "dev"]
EXPOSE 3000
