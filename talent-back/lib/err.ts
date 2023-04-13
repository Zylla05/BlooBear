import debuger, { Debugger } from 'debug';
import fs from 'fs';

const errlog : Debugger = debuger('server:err:');
/**
 * Error class wich include status code for manage on the server
 * @class
 * @extends Error
 */
export class HttpError extends Error {
	/**
	 * The http status code for the error
	 */
	public status: number;
	/**
	 * @param {string} message - The error message
	 * @param {number} status - The HTTP status code
	 */
	constructor( message: string, status: number ){
		super( message );
		this.status = status;
	}
}

/**
 * Error for functions o code that is not yet in the code so is easy to know what work needs to be done.
 * @class
 * @extends HttpError
 */
export class NoCodedYet extends HttpError {
	/**
	 * @param {string} engineer - The engineer's name whose has been asigned to this issue
	 * @param {string} funtionality - The name or resume of the code that supose to be here
	 */
	constructor( engineer: string, funtionality: string ){
		super(`${funtionality} has not been implemented yet. Consult ${engineer} engineer for more information.`, 501);
		this.name = `NoCodedYet/${funtionality}`;
	}
}

/**
 * Error due user typing something wrong
 * @class
 * @extends HttpError
 */
export class WrongUserInput extends HttpError {
	/**
	 * @param {string} message - The error message for the user
	 */
	constructor( message: string ){
		super(message, 400);
		this.name = "WrongUserInput";
	}
}

/**
 * The object does not exits in the data base or in any other part of the proyect
 * @class
 * @extends HttpError
 */
export class NotExist extends HttpError {
	/**
	 * @param {any} look - The param that was used to find the object
	 */
	constructor( look: any, obj: string ){
		super(`The ${obj} that was tried to find by ${look} does not exist on the database or any other part of the proyect`, 404);
		this.name = `${obj}NotExist`;
	}
}

export class GatewayFail extends HttpError {
	/**
	 * @param {string} message - The messgae error
	 * @param {number} status - the status code
	 */
	constructor( message:  string, status: number  ){
		super( message , status );
		this.name = 'GatewayFail';
	}
}

export class DataBaseFail extends HttpError {
	/**
	 * @param {string} message - The messgae error
	 * @param {number} status - the status code
	 */
	constructor( message:  string, status: number  ){
		super( message , status );
		this.name = 'DataBaseFail';
	}
}

/**
 * Write errors to file
 */
export function errsave( error: Error ){
	const message = new Date() + '\n' + error.stack + '\n\n';
	try{
		fs.promises.appendFile("err.log", message );
	}catch( e : any ){
		errlog( "Unable to write err.log: " + e.message );
		errlog( message );
	}
}
