import 'package:bloobear/Screens/historial.dart';
import 'package:bloobear/Screens/principal.dart';
import 'package:bloobear/Screens/userData.dart';
import 'package:bloobear/Screens/wellcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//------------------------------------------------------------------------Boton style---------------------------------------------------------------------------------------

Widget boton(hei, wid, context, text, route) {
  final ButtonStyle estiloboton = ElevatedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(105, 159, 183, 1),
      shadowColor: const Color.fromRGBO(76, 108, 132, 1),
      minimumSize: Size(wid * 0.8, hei * 0.03),
      maximumSize: Size(wid * 0.8, hei * 0.06),
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))));
  return ElevatedButton(
    style: estiloboton,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: const TextStyle(fontSize: 100.0),
      ),
    ),
    onPressed: () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      );
    },
  );
}

//------------------------------------------------------------------------Input style---------------------------------------------------------------------------------------

Widget input(wid, hei, texto) {
  return TextFormField(
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(105, 159, 183, 1)),
          borderRadius: BorderRadius.circular(5.5)),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(105, 159, 183, 1)),
          borderRadius: BorderRadius.circular(5.5)),
      labelText: texto,
      labelStyle: TextStyle(
          fontSize: hei * 0.025, color: const Color.fromRGBO(76, 108, 132, 1)),
      filled: true,
      fillColor: const Color.fromRGBO(105, 159, 183, 0.3),
    ),
  );
}

//------------------------------------------------------------------------ Menu ---------------------------------------------------------------------------------------

class Menu extends StatelessWidget {
  const Menu({
    super.key,
    required this.hei,
    required this.wid,
  });

  final double hei;
  final double wid;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color.fromRGBO(105, 159, 183, 1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: hei * 0.01),
              child: SizedBox(
                width: wid * 1,
                height: hei * 0.2,
                child: Image.asset("assets/images/bloobear.png"),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: wid * 1,
                  child: const ListTile(
                    title: Text(
                      "Bienvenido!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                    subtitle: Text(
                      "Nombre del usuario",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: wid * 0.5,
                      height: hei * 0.05,
                      child: ListTile(
                        title: const ImageIcon(
                          AssetImage("assets/icons/hogar.png"),
                        ),
                        trailing: const Text("Pagina principal"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Mapa(),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: wid * 0.5,
                      height: hei * 0.05,
                      child: ListTile(
                        title: const ImageIcon(
                          AssetImage("assets/icons/reloj.png"),
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: wid * 0.12),
                          child: const Text("Historial"),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Historial(),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: wid * 0.5,
                  height: hei * 0.05,
                  child: ListTile(
                    title: const ImageIcon(
                      AssetImage("assets/icons/usuario.png"),
                    ),
                    trailing: Padding(
                      padding: EdgeInsets.only(right: wid * 0.13),
                      child: const Text("Mi perfil"),
                    ),
                    onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserData(),
                              ));
                        },
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: wid * 0.1, vertical: hei * 0.025),
                  child: SizedBox(
                    width: wid * 0.5,
                    height: hei * 0.05,
                    child: ListTile(
                      title: const ImageIcon(
                        AssetImage("assets/icons/salida.png"),
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.only(right: wid * 0.05),
                        child: const Text("Cerrar sesión"),
                      ),
                      onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Wellcome(),
                              ));
                        },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ListElement extends StatelessWidget {
  const ListElement({
    super.key,
    required this.wid,
    required this.hei,
    required this.icon,
    required this.texto,
  });

  final double wid;
  final double hei;
  final String icon;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wid * 1,
      child: ListTile(
        leading: SizedBox(
          width: wid * 0.1,
          height: hei * 0.03,
          child: Image.asset(icon),
        ),
        title: Text(
          texto,
          style: TextStyle(color: Colors.white, fontSize: wid * 0.05),
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------ Lista de lugares ---------------------------------------------------------------------------------------

class LocationListTitle extends StatelessWidget {
  const LocationListTitle(
      {super.key, required this.location, required this.press});
  final String location;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double hei = size.height;
    final double wid = size.width;
    return Column(
      children: [
        ListTile(
          onTap: press,
          title: Text(
            location,
            maxLines: 2,
          ),
        ),
        const Divider(
          height: 2,
          thickness: 2,
          color: Color.fromRGBO(105, 159, 183, 1),
        ),
      ],
    );
  }
}
