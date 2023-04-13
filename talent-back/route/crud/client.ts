import { Request, Response, Router, NextFunction } from 'express';
import debuger from 'debug';
import Client from '../../obj/Client';

const router : Router = Router();
const debug = debuger("server:admin:");

router.get("/all", async (req: Request, res: Response, next: NextFunction) => {
	try{
		res.send( Client.all() );
	}catch( e ){
		next(e);
	}
});

router.get("/one/:id", async (req: Request, res: Response, next: NextFunction) => {
	try{
		debug( req.params );
		res.send( Client.invoke( parseInt( req.params.id ) ) );
	}catch( e ){
		next(e);
	}
});

router.post("/edit", async (req: Request, res: Response, next: NextFunction) => {
	try{
		debug( req.body );
		(await Client.invoke( parseInt( req.body.id ) )).update(
			req.body.name,
			req.body.email
		);
		res.status(201).send();
	}catch( e ){
		next(e);
	}
});

router.post("/delete", async (req: Request, res: Response, next: NextFunction) => {
	try{
		debug( req.body );
		(await Client.invoke( parseInt( req.body.id ) )).delete();
		res.status(201).send();
	}catch( e ){
		next(e);
	}
});

export default router;
