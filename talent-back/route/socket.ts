import { Server, Socket, Namespace } from 'socket.io';
import { createServer } from "http";
import debuger, { Debugger } from 'debug';
import { NoCodedYet, errsave } from '../lib/err';
import Iot from '../obj/Iot';
import Client from '../obj/Client';

const debug: Debugger = debuger("socket:");
const errlog: Debugger = debuger("socket:err:");
const httpServer = createServer();
const io: Server = new Server( httpServer, {
	cors: {
		origin: "*"
	}
});

export var iots: Iot[] = [];
export var clients: Client[] = [];

const adapter_client: Namespace = io.of("/client");
const adapter_iot: Namespace = io.of("/iot");

function askinfo() {
	var min = 1, max = 30;
	var rand = Math.floor(Math.random() * (max - min + 1) + min);
	adapter_iot.emit('status');
	setTimeout( askinfo, rand * 1000 );
}

export default function socket_setup(){
	io.on( 'connection', socket =>  {
		debug( typeof socket );
		debug( 'connection:' + socket.handshake.address );
	});
	adapter_iot.on('connection', socket =>  {
		debug( 'connection:' + socket.handshake.address );
		socket.emit('info');
		socket.on('info', async ( id ) => {
			debug( `iot: ${id}` );
			try{
				var iot = await Iot.invoke( id );
				iot.socket = socket;
				iots.push( iot );
				debug( iots.map( iot => iot.toJson() ) );
			}catch( e: any ) {
				errsave( e );
				socket.emit('err', e.name );
				errlog( e.name );
				socket.disconnect();
			}
		});

		socket.on('status', status =>{
			debug( status );
		});

		socket.on('ubi', ubi => {
			debug( ubi );
			adapter_client.emit( 'ubi', ubi );
		});

		socket.on('disconnect', reason => {
			errlog( reason );
			var iot = iots.find( iot => iot.socket == socket );
			if( iot == undefined ) return;
			adapter_client.emit( 'lost', iot.id );
			const index = iots.indexOf( iot );
			if( index == -1 ) return;
			iots.splice( index, 1 );
		});
	});

	adapter_client.on("connection", (socket: Socket) => {
		debug( 'client connection:' + socket.handshake.address );
		socket.on("ubi", ( ubi ) => {
			debug( ubi );
			socket.emit('ubi', ubi );
		});

		socket.on('info', async ( pkg ) => {
			debug( `client: ${pkg.id}` );
			try{
				var client = await Client.invoke( pkg.id );
				client.socket = socket;
				clients.push( client );
				debug( clients.map( client => client.toJson() ) );
			}catch( e : any) {
				errlog( e.name );
				errsave( e );
				socket.emit('err', e.name );
				socket.disconnect();
			}
		});
	});

	httpServer.listen(3001);
	debug( 3001 );
	//askinfo();
}
