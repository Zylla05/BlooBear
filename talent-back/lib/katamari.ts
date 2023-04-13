import Iot from "../obj/Iot";
import { GatewayFail } from "./err";

const url: string = "http://localhost:4000";

export default class katamari {
	static async genwallet(){
		var response = await fetch( `${url}/genwallet` );
		if( response.status >= 400 )
			throw new GatewayFail( await response.text(), response.status );
		return await response.text();
	}

	static async getnft( mint: string ){
		var response = await fetch( `${url}/getnft`, {
			method: 'POST',
			headers: {
				"Content-Type": "application/json",
			},
			body: JSON.stringify({
				mint: mint
			})
		} );
		if( response.status >= 400 )
			throw new GatewayFail( await response.text(), response.status );
		return response;
	}

	static async strikenft( mint: string ){
		var response = await fetch( `${url}/mintnft`, {
			method: 'POST',
			headers: {
				"Content-Type": "application/json",
			},
			body: JSON.stringify({
				mint: mint
			})
		} );
		if( response.status >= 400 )
			throw new GatewayFail( await response.text(), response.status );
		return await response.text();
	}

	static async mintnft( pubk: string, iot: Iot ): Promise<string>{
		var response = await fetch( `${url}/mintnft`, {
			method: 'POST',
			headers: {
				"Content-Type": "application/json",
			},
			body: JSON.stringify({
				pub: pubk,
				iot: JSON.stringify(iot.toJson())
			})
		} );
		if( response.status >= 400 )
			throw new GatewayFail( await response.text(), response.status );
		return await response.text();
	}
}

async function main () {
	var res = await katamari.getnft("B3xV12y2YA9YtuD15zHSm1tmWSJp6ZKo3QSLM7hRg8Et");
	console.log( await res.json() );
}
main();
