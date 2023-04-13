/*INicio de sesion y registro alv */
const url = "http://192.168.100.24:3000";
const data = {
	name: 'Tester Client',
	email: "test@mail.com",
	password: "@TestPass01"
};
function eliminarUsuario(){
	fetch(url + "/delete", {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json'
		},
		body: JSON.stringify( data )
	}).then( response => {
		console.log( response.text() );
	});
}

async function main() {
	/*var response = await fetch(url + "/register", {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json'
		},
		body: JSON.stringify( data )
	});
	console.log( await response.text() );*/
	response = await fetch(url + "/login", {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json'
		},
		body: JSON.stringify( data )
	});
	console.log(await response.text());
	//Mandar la siguiente cadena al html. El usuario id_usuario se ha loggeado. Donde usuario_id viene en response.text
	//INicializa el socket para comunicarnos con el ELT
	/*console.log( await response.text() );
	const socket = io("ws://localhost:3001/");
	socket.open();
	socket.on( 'info', () => {
		socket.emit('info', 0 );
	});
	socket.on('err', msg => {
		console.log( msg );
		socket.disconnect();
	});*/
}
//EL usuario se registre, inicie sesión, loggeo, pida carros
//Hacer un showcase 

main();
