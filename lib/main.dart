import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:exportar_database/manejarbd.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exportar Base de Datos'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  // para solicitr permisos de lectura y escritura
                  var status = await Permission.storage.request();
                  if (status.isGranted) {
                    // permite exportar la bd si se otorgan los permisos
                    await createAndExportDatabase();
                  } else {
                    print('Permiso de almacenamiento no otorgado');
                  }
                },
                child: const Text('Exportar Base de Datos'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // funcion para crear la base de datos y agregar datos de ejemplo
  Future<void> createAndExportDatabase() async {
    try {
      final manejarbd = Manejarbd();
      final sourceDatabase = await manejarbd.database;

      await sourceDatabase!.transaction((txn) async {
        await txn.execute('''
        CREATE TABLE IF NOT EXISTS tabla1 (
          id INTEGER PRIMARY KEY,
          nombre TEXT
        )
      ''');

        await txn.rawInsert('INSERT INTO tabla1 (nombre) VALUES (?)', ['x1']);
        await txn.rawInsert('INSERT INTO tabla1 (nombre) VALUES (?)', ['x2']);
      });

      final externalStorageDir = await getExternalStorageDirectory();
      final destinationPath = join(externalStorageDir!.path, 'VenAmbulante.db');

      // para copiar la bd al almacenamiento externo del dispositivo
      await File(sourceDatabase.path).copy(destinationPath);

      print('Base de datos exportada a: $destinationPath');
    } catch (e) {
      print('Error al exportar la base de datos: $e');
    }
  }
}