import 'package:flutter/material.dart';
import "package:velocity_x/velocity_x.dart";
import 'package:conversortemp/pages/convertionTempPage.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AppBar"),
      ),
      body: ConvertionTemp(),
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(child: Text("data")),
            ListTile(
              title: Text("cu"),
            )
          ],
        ),
      ),
    );
  }
}
