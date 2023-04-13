import { Request, Response, Router, NextFunction } from 'express';
import { HttpError } from '../lib/err';
import { getjwt, Token } from '../lib/jwt';
import admin_router from './crud/admin';
import client_router from './crud/client';
import iot_router from './crud/iot';

const router : Router = Router();

router.use( async (req: Request, res: Response, next: NextFunction) => {
	try{
		const token: Token = getjwt( req ) as Token;
		if( ! token.super )
			throw new HttpError( "Tried to login as admin, you are to allowed!", 403);
		next();
	}catch(e){next(e);}
});

router.use( '/admin', admin_router );
router.use( '/client', client_router );
router.use( '/iot', iot_router );

export default router;
