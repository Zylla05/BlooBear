import dbcall, { DBres } from '../lib/mysql';
import { NotExist } from '../lib/err';
import validator from '../lib/validate';
import debuger from 'debug';

const debug = debuger("server:lib:client:");

export default class Admin {

	public id: number | undefined;
	public name: string;
	public email: string;
	public password: string;

	public toJson(): any {
		return {
			id: this.id,
			name: this.name,
			email: this.email
		}
	}

	static async invoke( looker: number | string ): Promise<Admin> {
		var response: DBres;
		if( typeof looker == "number" ){
			response = await dbcall( 'CALL GET_ADMIN_BY_ID( ? )', [looker] );
		} else {
			validator.email( looker );
			response = await dbcall( 'CALL GET_ADMIN_BY_EMAIL( ? )', [looker] );
		}
		if( response.results.length == 0 )
			throw new NotExist( looker, 'Admin' );
		var admin = new Admin(
			response.results[1].name_admin,
			response.results[2].mail_admin,
			response.results[3].pass,
		);

		if( typeof looker == "number" )
			admin.id = looker;
		else
			admin.id = response.results[0].id_admin 
		
		return admin;
	}

	static async all(): Promise<Admin[]> {
		const response: DBres = await dbcall('CALL GET_ADMINS()',[]);
		var admins: Admin[] = [];
		response.results.forEach( ( res ) =>{
			var admin = new Admin(
				res[1].name_admin,
				res[2].mail_admin,
				res[3].pass
			);
			admin.id = res[0].id_admin;
		});
		return admins;
	}

	constructor( name: string, email: string, password: string ){
		validator.nickname( name );
		validator.email( email );
		this.name = name;
		this.email = email;
		this.password = password;
	}

	async store(){
		var response: DBres;
		if( this.id == undefined ){
			response = await dbcall( 'CALL CREATE_ADMIN(?,?,?,?)', [
				this.name,
				this.email,
				this.password
			]);
			this.id = response.results[0][0];
			debug(`New admin = ${this.id} on db`);
		} else {
			await dbcall( "SET_ADMIN_NAME(?,?)", [this.id, this.name] ); 
			await dbcall( "SET_ADMIN_MAIL(?,?)", [this.id, this.email] );
			await dbcall( "SET_ADMIN_PASS(?,?)", [this.id, this.password] );
			debug(`Update client = ${this.id} on db`);
		}
	}

	async update( name: string, email: string, password: string ){
		this.name = name;
		this.email = email;
		this.password = password;
		await this.store();
	}

	async delete(){
		if( this.id == undefined )
			throw new NotExist( this.id, 'Admin' );
		await dbcall( 'CALL DELETE_ADMIN( ? )', [ this.id ] );
		debug(`User with id ${this.id} has been deleted from database`);
	}
}
