import dbcall, { DBres } from '../lib/mysql';
import { NotExist, NoCodedYet } from '../lib/err';
import validator from '../lib/validate';
import debuger from 'debug';
import { Socket } from 'socket.io';

const debug = debuger("server:obj:client:");

export default class Client {

	id: number | undefined;
	name: string;
	email: string;
	wallet: string;
	socket?: Socket;

	public toJson(): any {
		return {
			id: this.id,
			name: this.name,
			email: this.email,
			wallet: this.wallet
		}
	}

	static async invoke( looker: number | string ): Promise<Client> {
		var response: DBres;
		if( typeof looker == "number" ){
			response = await dbcall( 'CALL GET_CLIENT_BY_ID( ? )', [looker] );
		} else {
			validator.email( looker );
			response = await dbcall( 'CALL GET_CLIENT_BY_MAIL( ? )', [looker] ); }
		if( response.results.length == 0 )
			throw new NotExist( looker, 'Client' );

		var client = new Client(
			response.results[0].name_client,
			response.results[0].mail_client,
			response.results[0].wallet
		);

		if( typeof looker == "number" )
			client.id = looker;
		else
			client.id = response.results[0].id_client 
		
		return client;
	}

	static async all(): Promise<Client[]> {
		const response: DBres = await dbcall('CALL GET_CLIENTS()',[]);
		var clients: Client[] = [];
		response.results.forEach( ( res ) =>{
			var client = new Client(
				res[1].name_client,
				res[2].mail_client,
				res[3].wallet
			);
			client.id = res[0].id_client;
		});
		return clients;
	}

	constructor( name: string, email: string, wallet: string ){
		validator.nickname( name );
		validator.email( email );
		this.name = name;
		this.email = email;
		this.wallet = wallet;
	}

	async store(){
		var response: DBres;
		if( this.id == undefined ){
			response = await dbcall( 'CALL CREATE_CLIENT(?,?,?)', [
				this.name,
				this.email,
				this.wallet
			]);
			if( response.results.length == 0 )
				throw new NoCodedYet( "Amaro", "CREATE_CLIENT__RETURN_ID" );
			this.id = response.results[0].id_client;
			debug(`New client = ${this.id} on db`);
		} else {
			await dbcall( "CALL SET_CLIENT_NAME(?,?)", [this.id, this.name]);
			await dbcall( "CALL SET_CLIENT_MAIL(?,?)", [this.id, this.email]);
			debug(`Updated client = ${this.id} on db`);
		}
	}
	
	async update( name: string, email: string ){
		this.name =  name;
		this.email = email;
		await this.store();
	}

	async delete(){
		if( this.id == undefined )
			throw new NotExist( this.id, 'Client' );
		await dbcall( 'CALL DELETE_CLIENT( ? )', [ this.id ] );
		debug(`Deleted client = ${this.id} on db`);
	}
}
