import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Product {
  final int id;
  final String title;

  Product(this.id, this.title);

  @override
  String toString() {
    return '{id: $id, title: $title}';
  }
}

class DatabaseManager {
  late DatabaseFactory databaseFactory;
  late Database database;

  Future<void> initialize() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    database = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await database.execute('''
      CREATE TABLE Product (
          id INTEGER PRIMARY KEY,
          title TEXT
      )
    ''');
    await database.insert('Product', <String, Object?>{'title': 'Product 1'});
    await database.insert('Product', <String, Object?>{'title': 'Product 1'});
  }

  Future<List<Product>> getProducts() async {
    var results = await database.query('Product');
    return results
        .map((row) => Product(row['id'] as int, row['title'] as String))
        .toList();
  }

  Future<void> close() async {
    await database.close();
  }
}

Future<void> main() async {
  var manager = DatabaseManager();
  await manager.initialize();

  var products = await manager.getProducts();
  print(products);

  await manager.close();
}
