import 'package:flutter/material.dart';

import '../Widgets.dart';

class Historial extends StatefulWidget {
  const Historial({super.key});

  @override
  State<Historial> createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  final List<Item> data = List<Item>.generate(10, (index) {
    return Item(titulo: "item $index", subtitulo: "Prueba de items");
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
