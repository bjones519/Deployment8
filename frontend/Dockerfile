
FROM node:10.0

RUN git clone https://github.com/bjones519/Deployment8.git

WORKDIR Deployment8/frontend

RUN npm install

EXPOSE 3000

ENTRYPOINT [ "npm", "start" ]
