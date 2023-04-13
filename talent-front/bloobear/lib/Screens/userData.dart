import 'package:bloobear/Widgets.dart';
import 'package:flutter/material.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double hei = size.height;
    final double wid = size.width;
    TextStyle estilo =
        TextStyle(fontSize: wid * 0.04, fontWeight: FontWeight.bold);
    return Scaffold(
      drawer: Menu(hei: hei, wid: wid),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(105, 159, 183, 1),
        centerTitle: true,
        title: const Text("Confirmar dirección"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: wid * 0.3,
            height: hei * 0.3,
            child: Image.asset("assets/images/User.png"),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: hei*0.03),
            child: Text(
              "Datos del usuario",
              style: TextStyle(fontSize: hei * 0.05, fontWeight: FontWeight.w900),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(hei * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children:  [
                Text("Nombre del usuario",style: estilo,),
                Text("Nombre del usuario",style: estilo,)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(hei * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children:  [
                Text("Correo del usuario",style: estilo,),
                Text("Correo del usuario", style: estilo,)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(hei * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children:  [
                Text("Wallet del usuario",style: estilo,),
                Text("Wallet del usuario", style: estilo,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
