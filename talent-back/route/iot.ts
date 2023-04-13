import { Request, Response, Router, NextFunction } from 'express';
import debuger, { Debugger } from 'debug';
import { NoCodedYet, errsave, WrongUserInput } from '../lib/err';
import Iot from '../obj/Iot';
import { iots } from './socket';
import katamari from '../lib/katamari';
import { Token, getjwt } from '../lib/jwt';
import Client from '../obj/Client';

const router : Router = Router();
const debug: Debugger = debuger("server:iot:");
const errlog: Debugger = debuger("server:err");


router.post("/rent", async (req: Request, res: Response, next: NextFunction) => {
	try{
		debug( req.body );
		const token: Token = getjwt( req ) as Token;
		var iot: Iot | undefined = iots.find( iot => iot.id == req.body.id );
		if( iot == undefined || iot.socket == undefined )
			throw new WrongUserInput( "This car is not online" );
		const client: Client = await Client.invoke( token.id );
		debug( client );
		const mint = await katamari.mintnft( client.wallet, iot );
		iot.socket.emit('/rent', { mint: mint, wallet: client.wallet } );
		debug(mint);
		res.status(201).send(mint);
	}catch( e ){
		next(e);
	}
});

router.get("/list", async (req: Request, res: Response, next: NextFunction) => {
	try{
		res.send( await Iot.all() );
	}catch( e ){
		next(e);
	}
});

router.get("/:id", async (req: Request, res: Response, next: NextFunction) => {
	try{
		res.send( await Iot.invoke( parseInt( req.params.id ) ));
	}catch( e ){
		next(e);
	}
});

router.get("/online", async (req: Request, res: Response, next: NextFunction) => {
	try{ res.send( iots );
	}catch( e ){
		next(e);
	}
});

export default router;
