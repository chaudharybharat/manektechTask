import 'package:manektechtask/db/table_name.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/cart_model.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'flutter_sqflite_database.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to Product
  // and a table to store dogs.
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {breeds} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE ${TableName.productTable}(${TableName.productId} INTEGER PRIMARY KEY, ${TableName.productQuantity} INTEGER, ${TableName.productTitle} TEXT, ${TableName.productDescription} TEXT, ${TableName.productPrice} TEXT, ${TableName.productFeaturedImage} TEXT)',
    );
  }

  // Define a function that inserts Product into the database
  Future<int> insertProduct(CartModel productList) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Insert the Product into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same breed is inserted twice.
    //
    // In this case, replace any previous data.
   return await db.insert(
      TableName.productTable,
      productList.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }



  // A method that retrieves all the Product from the Product table.
  Future<List<CartModel>> productCart() async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Query the table for all the Product.
    final List<Map<String, dynamic>> maps = await db.query(TableName.productTable);

    return List.generate(maps.length, (index) => CartModel.fromMap(maps[index]));
  }

  Future<CartModel> getProductCart(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query(TableName.productTable, where: '${TableName.productId} = ?', whereArgs: [id]);
     if(maps!=null && maps.length>0){
       return CartModel.fromMap(maps[0]);
     }
     return null;

  }



  // A method that updates a Product data from the Product table.
  Future<void> updateCart(CartModel breed) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Update the given Product
    await db.update(
      TableName.productTable,
      breed.toMap(),
      // Ensure that the Product has a matching id.
      where: '${TableName.productId} = ?',
      // Pass the Product's id as a whereArg to prevent SQL injection.
      whereArgs: [breed.id],
    );
  }


  // A method that deletes a Product data from the Product table.
  Future<void> deleteCart(int id) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Remove the Product from the database.
    await db.delete(
      TableName.productTable,
      // Use a `where` clause to delete a specific Product.
      where: '${TableName.productId} = ?',
      // Pass the Product's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }


}
