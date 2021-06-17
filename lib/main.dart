import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expense_tracker/add_screen.dart';
import 'package:expense_tracker/database.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/utils.dart';
import 'package:expense_tracker/widget/dismissible_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Мои расходы'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _database = ExpensesDatabase();

  _MyHomePageState() {
    this._database.fetch().then((value) => setState(() {}));
  }

  void dismissItem(context, index, direction) async {
    switch (direction) {
      case DismissDirection.endToStart:
        await this._database.removeAt(index);
        Utils.showSnackBar(context, 'Элемент был удален');
        break;
      case DismissDirection.startToEnd:
        await this._database.removeAt(index);
        Utils.showSnackBar(context, 'Элемент был изменен');
        break;
      default:
        break;
    }
    await this._database.fetch();
    setState(() {});
  }

  Widget buildListTile(Expense item) =>
      ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.description,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(DateFormat.yMMMMd().format(item.date))
          ],
        ),
        trailing: Text(
            item.price.toString() + ' ₽',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            )
        ),
        onTap: () {},
      );

  Future<bool> confirmStartToEndDismiss(item) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return AddScreen(this._database, 'Редактирование', item);
        })
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title),
              Container (
                child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Всего: ${this._database.expenses.length}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'На сумму: ${this._database.expenses.fold(0, (sum, next) => sum + next.price)} ₽',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.separated(
              itemCount: this._database.expenses.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final item = this._database.expenses[index];
                return DismissibleWidget(
                  item: item,
                  child: buildListTile(item),
                  onDismissed: (direction) =>
                      dismissItem(context, index, direction),
                  confirmStartToEndDismiss: confirmStartToEndDismiss,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var expense = Expense(null, null, null, DateTime.now());
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return AddScreen(_database, 'Добавление', expense);
              })
          ).then((value) => this._database.fetch()).then((value) => setState(() {}));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}