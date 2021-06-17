class Expense {
  int _id;
  String _description;
  double _price;
  DateTime _date;

  int get id => _id;
  String get description => _description;
  double get price => _price;
  DateTime get date => _date;

  set date(DateTime date) {
    this._date = date;
  }

  Expense(this._id, this._description, this._price, this._date);
}