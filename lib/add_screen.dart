import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  final _database;
  final _expense;
  final title;

  AddScreen(this._database, this.title, this._expense);

  @override
  State<StatefulWidget> createState() {
    return AddScreenState(_database, _expense);
  }
}

class AddScreenState extends State<AddScreen> {
  var _formState = GlobalKey<FormState>();
  var _database;
  var _expense;
  // var _id;
  var _description;
  var _price;

  AddScreenState(this._database, this._expense);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formState,
        child: Container(
          margin: EdgeInsets.all(30.0),
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.topCenter,
          child: Column(children: [
            TextFormField(
              initialValue: this._expense.description ?? '',
              decoration: InputDecoration(
                  labelText: 'Введите наименование товара'
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLengthEnforced: false,
              maxLength: 30,
              validator: (value) {
                if (value.length < 3) {
                  return 'Название не должно быть короче 3 символов';
                }
                return null;
              },
              onSaved: (value) {
                this._description = value;
              },
            ),
            TextFormField(
              initialValue: this._expense.price?.toString(),
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLengthEnforced: false,
              maxLength: 13,
              decoration: InputDecoration(
                labelText: 'Введите стоимость',
                hintText: 'Пример: 49.99'
              ),
              validator: (value) {
                var price = double.tryParse(value);
                if (price == null) {
                  return 'Допустимые символы: 0-9 и .';
                }
                if (price <= 0) {
                  return 'Цена должна быть положительным числом';
                }

                return null;
              },
              onSaved: (value) {
                this._price = double.parse(value);
              },
            ),
            Row(children: [
              Text(
                'Выберите дату',
                style: TextStyle(
                  fontSize: 16,
                  // color: Colors.black,
                ),
              ),
              TextButton(
                child: Icon(Icons.date_range_rounded, color: Colors.black, size: 32),
                onPressed: () async {
                  var now = DateTime.now();
                  this._expense.date = await showDatePicker(
                      context: context,
                      initialDate: this._expense.date ?? now,
                      firstDate: DateTime(now.year, now.month, 1),
                      lastDate: now,
                  );
                }
              )
            ]),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.green,
                    minimumSize: Size(100, 50),
                    padding: EdgeInsets.only(
                        left: 60,
                        right: 60,
                        top: 15,
                        bottom: 15
                    )
                ),
                onPressed: () async {
                  if (_formState.currentState.validate()) {
                    _formState.currentState.save();

                    await this._database.add(
                        this._description,
                        this._price,
                        this._expense.date
                    );
                    Navigator.of(context).pop(true);
                  }
                },
                child: Text('Сохранить')
              ),
            ),
          ]),
        ),
      ),
    );
  }
}