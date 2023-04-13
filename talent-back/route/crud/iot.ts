import { Request, Response, Router, NextFunction } from 'express';
import debuger from 'debug';
import Iot from '../../obj/Iot';

const router : Router = Router();
const debug = debuger("server:admin:");

router.get("/all", async (req: Request, res: Response, next: NextFunction) => {
	try{
		res.send( Iot.all() );
	}catch( e ){
		next(e);
	}
});

router.get("/one/:id", async (req: Request, res: Response, next: NextFunction) => {
	try{
		debug( req.params );
		res.send( Iot.invoke( parseInt( req.params.id ) ) );
	}catch( e ){
		next(e);
	}
});

router.get("/edit", async (req: Request, res: Response, next: NextFunction) => {
	try{
		debug( req.body );
		(await Iot.invoke( parseInt( req.body.id ) )).update(
			req.body.plate,
			req.body.TC,
		);
	}catch( e ){
		next(e);
	}
});

router.post("/delete", async (req: Request, res: Response, next: NextFunction) => {
	try{
		debug( req.body );
		(await Iot.invoke( parseInt( req.body.id ) )).delete();
	}catch( e ){
		next(e);
	}
});

export default router;
