import { Request, Response, Router, NextFunction } from 'express';
import { NoCodedYet, GatewayFail, HttpError, WrongUserInput } from '../lib/err';
import Client from '../obj/Client';
import Admin from '../obj/Admin';
import { genjwt, Code, getjwt, Token } from '../lib/jwt';
import { sendmail } from '../lib/mail';
import debuger from 'debug';

const router : Router = Router();
const debug = debuger("server:index:");

router.post("/login", async (req: Request, res: Response, next: NextFunction) => {
	try{
		debug( req.body );
		const code = new Code();
		sendmail( (await Client.invoke( req.body.email )).email, code.code );
		res.status(201);
		res.type("txt");
		return res.send(genjwt( code, "3m" ));
	}catch( e ){ next(e); }
});

router.post("/init", async (req: Request, res: Response, next: NextFunction) => {
	try{
		debug( req.body );
		const code: Code = getjwt( req ) as Code;
		const client = await Client.invoke( req.body.email );
		if( client.id == undefined )
			throw new HttpError( "Client register was readed from dsatabase without id", 500 );
		debug( req.body.code );
		debug( code.code );
		if( code.code == req.body.code ){
			res.status(201);
			res.type("txt");
			return res.send( genjwt( { id: client.id, super: false }) );
		}
		throw new WrongUserInput("Código de verificación erroneo");
	}catch(e){ next(e); }
});

router.post("/admin/login", async (req: Request, res: Response, next: NextFunction) => {
	try{
		debug( req.body );
		var admin: Admin = await Admin.invoke( req.body.email );
		admin = await Admin.invoke( req.body.email );
		if( admin.password == req.body.password ){
			res.status(200);
			res.type('text');
			if( admin.id == undefined )
				throw new Error("Missing id even on success db query");
			return res.send(genjwt( { id: admin.id, super: true } ));
		}else{
			res.status(401);
			res.type('text');
			return res.send("Contraseña erronea");
		}
	}catch( e ){ next(e); }
});

router.post("/register", async (req: Request, res: Response, next: NextFunction) => {
	try{
		debug( req.body );
		const url = process.env.npm_package_config_katamariurl || 
			"http://localhost:4000";
		var response = await fetch( `${url}/genwallet` );

		if( response.status >= 400 )
			throw new GatewayFail( await response.text(), response.status );

		const client: Client = new Client(
			req.body.name,
			req.body.email,
			await response.text()
		);
		debug( client );
		await client.store();
		res.status(201).send();
	}catch( e ){
		next(e);
	}
});

export default router;
