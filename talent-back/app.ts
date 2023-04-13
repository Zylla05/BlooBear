import express, { Express, Request, Response, NextFunction } from 'express';
import debuger, { Debugger } from 'debug';
import index_router from './route/index';
import admin_router from './route/admin';
import client_router from './route/client';
import iot_router from './route/iot';
import cors from 'cors';
import { HttpError, errsave } from './lib/err';
import socket_setup from './route/socket';

const app: Express = express();
const debug : Debugger = debuger('server:');
const errlog : Debugger = debuger('server:err:');
const port : number = parseInt( process.env.npm_package_config_port || "8080" );

app.use(cors());
app.use(express.json());

app.use('/', async (req: Request, res: Response, next: NextFunction): Promise<void> => {
	debug(req.method + '.' + req.url);
	next();
});

app.use("/", index_router);
app.use("/admin", admin_router);
app.use("/client", client_router);
app.use("/iot", iot_router);

app.use("/", (req: Request, res: Response): void => {
	res.status(404);
	res.send();
});

app.use( async (error: HttpError, req: Request, res: Response, next: NextFunction): Promise<void> => {
	errlog( error.name );
	errsave( error );
	res.type("text");
	if( error.status == undefined || error.status < 400 ){
		res.status( 500 );
		res.send( error.message );
		//res.send("Server error, please try later");
		return;
	}
	res.status( error.status );
	if( error.status >= 500 )
		res.send( error.message );
		//res.send("Server error, please try later");
	else
		res.send( error.message );
});

socket_setup();

app.listen(port, () => {
	debug( port );
});
