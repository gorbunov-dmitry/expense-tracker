import 'package:flutter/material.dart';

class DismissibleWidget<T> extends StatelessWidget {
  final T item;
  final Widget child;
  final DismissDirectionCallback onDismissed;
  final confirmStartToEndDismiss;

  const DismissibleWidget({
    @required this.item,
    @required this.child,
    @required this.onDismissed,
    @required this.confirmStartToEndDismiss,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Dismissible(
    key: ObjectKey(item),
    background: buildSwipeActionLeft(),
    secondaryBackground: buildSwipeActionRight(),
    child: child,
    onDismissed: onDismissed,
    confirmDismiss: (direction) => processSwipeDirection(context, direction)
  );

  Widget buildSwipeActionLeft() => Container(
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.symmetric(horizontal: 20),
    color: Colors.blue,
    child: Icon(Icons.edit_rounded, color: Colors.white, size: 32),
  );

  Widget buildSwipeActionRight() => Container(
    alignment: Alignment.centerRight,
    padding: EdgeInsets.symmetric(horizontal: 20),
    color: Colors.red,
    child: Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 32),
  );

  Future<bool> processSwipeDirection(BuildContext context, DismissDirection direction) async {
    if (direction == DismissDirection.endToStart) {
      var result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            'Удаление',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Вы действительно хотите удалить выбранный элемент?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Удалить'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        ),
      );
      return result ?? false; // In case the user dismisses the dialog by clicking away from it
    }
    var result = await confirmStartToEndDismiss(this.item);
    return result;
  }
}