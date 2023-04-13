import { WrongUserInput } from './err';

export default class validator {

	public static email_re: RegExp = /^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
	public static nickname_re: RegExp = /^[a-zA-Z ]{3,26}$/;
	public static password_re: RegExp = /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[@$!%*?&])[A-Za-z0-9@$!%*?&]{8,20}$/;

	static testNUll( arg: any, name: string ): void {
		if( arg == undefined || arg == null || arg == "" )
			throw new WrongUserInput(`El parametro '${name}' no fue recibido.`);
	}
	static login( body: any ): void {
		this.testNUll( body, "cuerpo de la petición" );
		this.email( body.email );
		this.password( body.password );
	}

	static nickname( nickname: string ): void {
		this.testNUll( nickname, "nombre de usario" );
		if( ! this.nickname_re.test( nickname ) )
			throw new WrongUserInput("El nombre de usuario solo debe contener caracteres afabeticos y espacios. Además deber tener una longitud minima de tres caracteres y máxima de 26");
	}

	static email( email: string ): void {
		this.testNUll( email, "correo electronico" );
		if( ! this.email_re.test( email ) )
			throw new WrongUserInput("El correo no cumple con el formato esperado");
	}

	static password( password: string ): void {
		this.testNUll( password, "correo electronico" );
		if( ! this.password_re.test( password ) )
		   	throw new WrongUserInput("Se requiere que la contraseña tenga entre 8 y 20 caracteres de longitud y contenga al menos una letra minúscula, una letra mayúscula, un número y un carácter especial (@$!%*?&)");
	}
}
