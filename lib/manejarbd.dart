import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Manejarbd {
  static final Manejarbd _instance = Manejarbd._internal();

  factory Manejarbd() => _instance;

  static Database? _database;

  Manejarbd._internal();

  Future<Database?> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'VenAmbulante.db');

    // abre la base de datos y solo la crea si no existe
    return await openDatabase(path, version: 1);
  }
}