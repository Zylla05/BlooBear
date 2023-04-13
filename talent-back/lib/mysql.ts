import mysql, { QueryError, Connection } from 'mysql2';
import { NoCodedYet, HttpError, DataBaseFail } from './err';
import debuger from 'debug';

const debug = debuger("server:db:");

const config = {
	host: process.env.npm_package_config_sqladdress,
	user: process.env.npm_package_config_sqluser,
	password: process.env.npm_package_config_sqlpassword,
	database: process.env.npm_package_config_sqldatabase
}

var conn: Connection;

try{
	conn = mysql.createConnection(config);
}catch(e){

}

export interface DBres {
	results: any[];
	fields: string[];
}

export default function dbcall( query: string, args: any[] = [] ): Promise<DBres> {
	const sql = mysql.format( query, args );
	return new Promise( (resolve, reject) => {
		conn.query( sql, function ( err: QueryError, results: any[], fields: string[] ) {
			if( err ) {
				if( err.code == "ER_SP_DOES_NOT_EXIST" ){
					var ncy = new NoCodedYet( 'Amaro', query );
					ncy.message = `${err.message}. Probably: ${ncy.message}`;
					reject( ncy );
				}
				if( err.sqlState != undefined ){
					const status = parseInt( err.sqlState ) - 45000; 
					if( status >= 500 ) 
						reject( new DataBaseFail( err.message, status ) );
					else if( status >= 400 )
						reject( new HttpError( err.message, status ) );
				}
				err.name = err.code;
				err.message += `. On execute: ${sql}`;
				if( err.fatal )
					conn = mysql.createConnection(config);
				reject( err );
			}
			if( results == undefined )
				resolve( {
					results: [],
					fields: []
				} );
			else
				resolve( {
					results: results[0],
					fields: fields
				} );
		});
	});
}
