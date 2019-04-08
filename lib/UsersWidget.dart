import 'package:flutter/material.dart';
import 'package:pbasw_flutter_exam/TabsWidget.dart';

class UsersWidget extends TabPageWidget {
  UsersWidget({Key key}) : super(key: key, fabIcon: Icons.add);

  @override
  _UsersWidgetState createState() => _UsersWidgetState();
}

class _UsersWidgetState extends State<UsersWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
