import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:expense_tracker/model/expense.dart';

class ExpensesDatabase {
  final createTableQuery =
      'CREATE TABLE Expenses ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'description TEXT,'
        'price REAL,'
        'date TEXT'
      ')';

  final selectAllQuery =
      'SELECT * '
      'FROM Expenses '
      'ORDER BY date '
      'DESC';

  final insertRowQuery =
      'INSERT INTO Expenses '
      '(description, price, date) '
      'VALUES (?, ?, ?)';

  final deleteRowQuery =
      'DELETE FROM Expenses '
      'WHERE id == ?';

  var _database;
  var _expenses = List<Expense>();

  Future<Database> get database async {
    if (this._database == null) {
      var dir = await getApplicationDocumentsDirectory();
      var path = join(dir.path, 'database.db');
      this._database = await openDatabase(
        path,
        version: 1,
        onCreate: (database, version) async {
          await database.execute(this.createTableQuery);
        }
      );
    }
    return this._database;
  }

  List<Expense> get expenses => this._expenses;

  Future<void> fetch() async {
    this._expenses = await all();
  }

  Expense getAt(int index) {
    return this._expenses[index];
  }

  Future<void> removeAt(int index) async {
    var db = await this.database;
    await db.rawDelete(this.deleteRowQuery, [this._expenses[index].id]);
    this._expenses.removeAt(index);
  }

  Future<List<Expense>> all() async {
    var db = await this.database;
    var query = await db.rawQuery(this.selectAllQuery);
    var result = List<Expense>();
    for (var row in query) {
      // await db.rawDelete(this.deleteRowQuery, [row['id']]);
      var expense = Expense(
        row['id'],
        row['description'],
        row['price'],
        DateTime.parse(row['date']),
      );
      result.add(expense);
    }
    return result;
  }

  Future<void> add(String description, double price, DateTime date) async {
    var db = await this.database;
    await db.rawInsert(this.insertRowQuery, [description, price, date.toString()]);
    // await fetch();
  }
}
