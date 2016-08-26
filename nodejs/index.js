const uuid = require('node-uuid');
const WebSocketServer = require('websocket').server;
const http = require('http');
const generateMap = require('./generate-map');

const server = http.createServer((request, response) => {
  response.writeHead(404);
  response.end();
});

let players = [];

server.listen(3000, () => {
  console.log((new Date()) + ' Server is listening on port 3000');
});


const map = generateMap();

const wsServer = new WebSocketServer({
    httpServer: server,
    // You should not use autoAcceptConnections for production
    // applications, as it defeats all standard cross-origin protection
    // facilities built into the protocol and the browser.  You should
    // *always* verify the connection's origin and decide whether or not
    // to accept it.
    autoAcceptConnections: false
});

wsServer.on('request', request => {
  if (players.length === 4) return request.reject();

  const id = uuid.v1();

  let coords = { x: 1, y: 1 };

  switch (players.length) {
  case 0:
    break;
  case 1:
    coords = { x: 11, y: 1 };
    break;
  case 1:
    coords = { x: 11, y: 1 };
    break;
  case 1:
    coords = { x: 11, y: 1 };
    break;
  default:
    break;
  }

  players = players.concat({ id, coords });

  const connection = request.accept();

  const message = JSON.stringify({
    players
  });

  wsServer.connections.forEach(connection => connection.sendUTF(message));

  connection.on('message', message => {
    console.log(message);
  });

  connection.on('close', () => {
    players = players.filter(player => player.id !== id);

    const message = JSON.stringify({
      players
    });

    wsServer.connections.forEach(connection => connection.sendUTF(message));
  });
});
