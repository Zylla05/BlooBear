import dbcall, { DBres } from '../lib/mysql';
import { NotExist } from '../lib/err';
import debuger from 'debug';
import { Socket } from 'socket.io';

const debug = debuger("server:lib:iot:");

export interface IotStaus {
	motion: "park" | "off" | "driving" | "broken";
	user: "neutral" | "driving" | "unpresent"; 
}

export default class Iot {

	public id: number | undefined;
	public model: string;
	public brand: string;
	public plate: string;
	public motor: string;
	public NIV: string;
	public TC: string;
	public type: number;
	public socket?: Socket;
	public status?: IotStaus;
	public availability?: "InTravel" | "Available";

	public toJson() {
		return {
			id: this.id,
			model: this.model,
			brand: this.brand,
			plate: this.plate,
			TC: this.TC,
			status: this.status,
			availability: this.availability
		}
	}

	static async invoke( looker: number ): Promise<Iot> {
		var response: DBres;

		response = await dbcall( 'CALL GET_CAR_BY_ID( ? )', [looker] );

		if( response.results.length == 0 )
			throw new NotExist( looker, 'Iot' );

		var iot: Iot = new Iot(
			response.results[0].model,
			response.results[0].brand,
			response.results[0].plate,
			response.results[0].motor,
			response.results[0].NIV,
			response.results[0].TC,
			response.results[0].id_cat_type
		);

		iot.id = looker;
		
		return iot;
	}

	static async all(): Promise<Iot[]> {
		const response: DBres = await dbcall('CALL GET_CARS()',[]);
		var iots: Iot[] = [];
		response.results.forEach( ( res ) =>{
			var iot = new Iot(
				res[1],
				res[2],
				res[3],
				res[4],
				res[5],
				res[6],
				res[7]
			);
			iot.id = res[0];
		});
		return iots;
	}

	constructor( model: string, brand: string, plate: string, motor: string, NIV: string, TC: string, type: number ){
		this.model = model;
		this.brand = brand;
		this.plate = plate;
		this.motor = motor;
		this.NIV = NIV;
		this.TC = TC;
		this.type = type;
	}

	async store(){
		var res: DBres;
		if( this.id == undefined ){
			res = await dbcall( 'CALL CREATE_CAR(?,?,?,?,?,?,?)', [
				this.model,
				this.brand,
				this.plate,
				this.motor,
				this.NIV,
				this.TC,
				this.type
			]);
			this.id = res.results[0][0];
			debug(`New car = ${this.id} on db`);
		} else {
			await dbcall( 'CALL SET_CAR_PLATE(?,?)', [this.id, this.plate]);
			await dbcall( 'CALL SET_CAR_TC(?,?)', [this.id, this.TC ]);
			debug(`Update car = ${this.id} on db`);
		}
	}
	
	async update(plate: string, TC: string) {
		this.plate = plate;
		this.TC = TC;
		await this.store();
	}

	async delete(){
		if( this.id == undefined )
			throw new NotExist( this.id, 'Iot' );
		await dbcall( 'CALL DELETE_CAR( ? )', [ this.id ] );
		debug(`Delete car = ${this.id} on db`);
	}

	initSocket( socket: Socket ){
		this.socket = socket;
		socket.on( 'status', status => {
		});
	}
}
