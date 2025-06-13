import 'package:flutter/material.dart';
import 'package:reportes_unimayor/themes/light.theme.dart';

class MainUserScreen extends StatelessWidget {
  const MainUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Reportes UniMayor',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
        ),
      ),
      drawer: drawerUser(),
      body: Column(children: []),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        height: 90,
        child: Container(
          decoration: BoxDecoration(
            color: lightMode.colorScheme.secondary,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Realizar Reporte",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(icon: const Icon(Icons.send), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Drawer drawerUser() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/icons/logo_unimayor.png',
                    width: 80,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
