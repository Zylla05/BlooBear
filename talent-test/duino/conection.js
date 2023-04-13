//Conectarse con 10.14.1.157 y puerto 4000 mediante http
   //Enviar a Katamari 
const io = require('socket.io-client');
const socket = io('ws://10.14.1.157:3001/iot');
socket.on('connect', () => {
    socket.on('info', pkg =>{
        socket.emit('info',0);
    });
    
    console.log('Conectado a Katamari');
    });
/*async function getData() {
    try {
        const fetch = await import('node-fetch');
        const response = await fetch.default('http://10.14.1.157:4000/genwallet');
        const data = await response.json();
        console.log(data);
    } catch (error) {
        console.log(error);
    }
}*/
const {SerialPort} = require('serialport');
const {ReadlineParser} = require('@serialport/parser-readline');
const port = new SerialPort( {path:'COM5', baudRate: 9600 });
const parser = port.pipe(new ReadlineParser({ delimiter: '\n' }));
port.on('error', (err) => {
    console.error('Error en puerto serial:', err.message);
  });
 /* parser.on('data', function(data){
    // Si se detecta la señal "Tarjeta detectada", realiza una acción
    if (data === "Tarjeta detectada"){
        console.log("Tarjeta NFC detectada");
      // Aquí puedes agregar tu código para interactuar con la tarjeta NFC
    }
});
port.pipe(parser);*/

parser.on('data', (data) => {
  // Convertir el buffer a una cadena de texto
  const bufferString = data.toString();
  // Separar la cadena en dos partes usando la coma como delimitador
  const [latitud, longitud] = bufferString.split(',');
  // Convertir cada parte de la cadena a un número
  const latitudNum = parseFloat(latitud);
  const longitudNum = parseFloat(longitud);
  const id = 0;
  console.log(`Latitud: ${latitudNum}, Longitud: ${longitudNum}`);
  //Enviar a una funcion latiNum y longitudNum para enviarlos a otoro luga
  socket.emit('ubi', { id: id, alt: latitudNum, lat: longitudNum});

});
