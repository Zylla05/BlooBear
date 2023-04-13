import 'package:adminbloobear/pages/mapaAutos.dart';
import 'package:flutter/material.dart';

import '../Widgets.dart';

class Autos extends StatefulWidget {
  const Autos({super.key});

  @override
  State<Autos> createState() => _AutosState();
}

class _AutosState extends State<Autos> {
  final List<Item> data = List<Item>.generate(10, (index) {
    return Item(titulo: "Auto $index", subtitulo: "Prueba de items");
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double hei = size.height;
    final double wid = size.width;
    return Scaffold(
      drawer: Menu(hei: hei, wid: wid),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(105, 159, 183, 1),
        centerTitle: true,
        title: const Text("Historial de viajes"),
      ),
      body: SingleChildScrollView(
        child: ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          data[panelIndex].isExpanded = !isExpanded;
        });
      },
      children: data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(item.titulo),
            );
          },
          body: ListTile(
            title: Text(item.subtitulo),
            onTap: () {
              Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Mapa()),(route) => false,
        );
            },
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
        ),
      ),
    );
  }
}

class Item {
  Item(
      {required this.titulo, required this.subtitulo, this.isExpanded = false});
  String titulo;
  String subtitulo;
  bool isExpanded;
}
