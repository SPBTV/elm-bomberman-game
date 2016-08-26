const uuid = require('node-uuid');
const WebSocketServer = require('websocket').server;
const http = require('http');

const server = http.createServer((request, response) => {
  response.writeHead(404);
  response.end();
});

server.listen(3000, () => {
  console.log((new Date()) + ' Server is listening on port 3000');
});

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
  const connection = request.accept();
  const id = uuid.v1();

  const message = JSON.stringify({
    id
  });

  connection.sendUTF(message);

  connection.on('message', message => {
    connection.sendUTF(JSON.stringify({
      id,
      message: message.utf8Data
    }));
  });

  connection.on('close', (reasonCode, description) => {
    console.log(reasonCode, description);
    console.log(
      (new Date()) + ' Peer ' + connection.remoteAddress + ' disconnected.'
    );
  });
});
