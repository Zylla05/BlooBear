import { Request, Response, Router, NextFunction } from 'express';
import debuger from 'debug';
import Client from '../obj/Client';
import { getjwt, Token } from '../lib/jwt';
import { HttpError } from '../lib/err';

const router : Router = Router();
const debug = debuger("server:admin:");

declare global {
  namespace Express {
    interface Request {
      user: { id: number };
    }
  }
}

router.use( async (req: Request, res: Response, next: NextFunction) => {
	try{
		const token: Token = getjwt( req ) as Token;
		if( token.super )
			throw new HttpError( "You are an admin, why you here?", 401);
		req.user.id = token.id;
		next();
	}catch(e){next(e);}
});

router.get("/self", async (req: Request, res: Response, next: NextFunction) => {
	try{
		res.send( Client.invoke( req.user.id ) );
	}catch( e ){
		next(e);
	}
});

router.post("/edit", async (req: Request, res: Response, next: NextFunction) => {
	try{
		debug( req.body );
		(await Client.invoke( req.user.id )).update(
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
		(await Client.invoke( req.user.id )).delete();
		res.status(201).send();
	}catch( e ){
		next(e);
	}
});

export default router;
