import mailer , { SentMessageInfo }from 'nodemailer';
import debuger, { Debugger } from 'debug';

const debug: Debugger = debuger("server:mailer:");

const mail = "nykniu@zohomail.com";
const pass = "Y0D1Rmv8YMkV";
const prevtext = 'Chingas a tu jefa talent land. Ah sí, tu codigo: ';

// Y0D1Rmv8YMkV

let transport = mailer.createTransport({
	service: "Zoho",
	auth: {
		user: mail,
		pass: pass
	}
});

const opts = {
     from: mail,
     to: 'alainmontokvel@gmail.com', // List of recipients
     subject: 'Nykniu - BlooBear Team', // Subject line
     text: 'Chingas a tu jefa talent land. Ah sí, tu codigo: ', // Plain text body
};


export function sendmail( destiny: string, message: string ){
	opts.to = destiny;
	opts.text = prevtext + message;
	debug(`Sending email to ${destiny}`);
	transport.sendMail( opts, ( err: Error | null, info: SentMessageInfo ) =>{
		if( err ) throw err;
		debug( info.response );
	});
}
