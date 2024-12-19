FROM node:22

WORKDIR /app

# node_modules
COPY volumes/frontend/package.json .
COPY volumes/frontend/package-lock.json .
RUN npm i

CMD ["npm", "run", "dev"]
EXPOSE 3000
