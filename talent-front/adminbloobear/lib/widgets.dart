import 'package:adminbloobear/main.dart';
import 'package:adminbloobear/pages/autos.dart';
import 'package:adminbloobear/pages/isesion.dart';
import 'package:adminbloobear/pages/principal.dart';
import 'package:flutter/material.dart';

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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                builder: (context) => const Principal(),
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
                       AssetImage("assets/icons/auto.png"),
                     ),
                    trailing: Padding(
                      padding: EdgeInsets.only(right: wid * 0.05),
                      child: const Text("Automoviles"),
                    ),
                    onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Autos(),
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
                                builder: (context) => const InicioSesion(),
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