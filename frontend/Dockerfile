
FROM node:10

RUN git clone https://github.com/bjones519/Deployment8.git

WORKDIR Deployment8/frontend

RUN rm package-lock.json

RUN rm -rf node_modules

RUN npm install --save-dev @babel/plugin-proposal-private-property-in-object

RUN npm install

EXPOSE 3000

CMD [ "npm", "start" ]
