import jwt, { JwtPayload } from 'jsonwebtoken';
import { WrongUserInput } from './err';
import { Request } from 'express';

const secret: string = process.env.npm_package_config_secretKey || "defaultkey";
const ttl: string = process.env.npm_package_config_jwtttl || "1h";

export interface Token {
	id: number;
	super: boolean;
}

export class Code {
	public code : string;
	constructor( ){
		const randomNumber = Math.floor(Math.random() * 90000) + 10000;
		this.code = randomNumber.toString().padStart(5, '0');
	}
}

export function getjwt(req: Request): JwtPayload{
	var header: string | undefined = req.headers['authorization'];
	if( typeof header == 'undefined' )
		throw new WrongUserInput("The authorization header is empty" );
	var auth: string[] = header.split(' ');
	if( auth[0] != 'Bearer' )
		throw new WrongUserInput("The scheme for this authorization is wrong");
	const payload: JwtPayload | string = jwt.verify(
		auth[1],
		secret
	);

	if( typeof payload == 'string' )
		throw new Error("Expected a Token on JWT from client");
	return payload;
};

export function genjwt( token: Token | Code, time: string = ttl ): string {
	const payload: any = JSON.parse( JSON.stringify( token ) );
	return jwt.sign(
			payload,
			secret,
			{
				expiresIn: time
			}
		);
}
