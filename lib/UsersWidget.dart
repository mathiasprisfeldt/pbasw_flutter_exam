import 'package:flutter/material.dart';
import 'package:pbasw_flutter_exam/TabsWidget.dart';

class UsersWidget extends TabPageWidget {
  UsersWidget({Key key})
      : super(key: key, fabIcon: Icons.add, onFabPressed: OnFabPressedEvent());

  @override
  _UsersWidgetState createState() => _UsersWidgetState();
}

class _UsersWidgetState extends State<UsersWidget> {
  @override
  void initState() {
    super.initState();
    widget.onFabPressed?.addListener(onFabPressed);
  }

  @override
  void dispose() {
    super.dispose();
    widget.onFabPressed?.removeListener(onFabPressed);
  }

  void onFabPressed() {
    Navigator.of(context).pushNamed("/user");
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
