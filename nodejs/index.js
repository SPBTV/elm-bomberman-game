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

const isWall = (x, y) => {
  if (x % 2 === 0 && y % 2 === 0) return true;

  return false;
};

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

  const { x, y } = coords;

  players = players.concat({ id,x ,y });

  const connection = request.accept();

  const message = JSON.stringify({
    players
  });

  wsServer.connections.forEach(connection => connection.sendUTF(message));

  connection.on('message', ({utf8Data: keyCode}) => {
    // this is not real javascript keycodes it's returns from elm onkeydown handler
    // written by K. Vasilev
    switch (keyCode) {
      // left 'a'
      case '97':
        players = players.map(player => {
          if (
            player.id !== id ||
            player.x === 1 ||
            isWall(player.x - 1, player.y)
          ) return player;

          player.x = player.x - 1;
          return player;
        });
        break;
      // top 'w'
      case '119':
        players = players.map(player => {
          if (
            player.id !== id ||
            player.y === 1 ||
            isWall(player.x, player.y - 1)
          ) return player;

          player.y = player.y - 1;
          return player;
        });
        break;
      // right 'd'
      case '100':
        players = players.map(player => {
          if (
            player.id !== id ||
            player.x === 13 ||
            isWall(player.x + 1, player.y)
          ) return player;

          player.x = player.x + 1;
          return player;
        });
        break;
      // down 's'
      case '115':
        players = players.map(player => {
          if (
            player.id !== id ||
            player.y === 9  ||
            isWall(player.x, player.y + 1)
          ) return player;

          player.y = player.y + 1;
          return player;
        });
        break;
      // bomb! 'space'
      case '32':
        break;
      default:
        break;
    }

    const message = JSON.stringify({
      players
    });

    wsServer.connections.forEach(connection => connection.sendUTF(message));
  });

  connection.on('close', () => {
    players = players.filter(player => player.id !== id);

    const message = JSON.stringify({
      players
    });

    wsServer.connections.forEach(connection => connection.sendUTF(message));
  });
});
