import 'package:flutter/material.dart';
import 'package:pbasw_flutter_exam/TabsWidget.dart';
import 'package:pbasw_flutter_exam/builders/UserCard.dart';
import 'package:pbasw_flutter_exam/types/User.dart';
import 'package:pbasw_flutter_exam/services/RandomUserService.dart';

class RandomUsersWidget extends TabPageWidget {
  final RandomUserService randomUserService = RandomUserService();

  RandomUsersWidget({Key key})
      : super(
            key: key,
            fabIcon: Icons.refresh,
            onFabPressed: OnFabPressedEvent());

  @override
  _RandomUsersWidgetState createState() => _RandomUsersWidgetState();
}

class _RandomUsersWidgetState extends State<RandomUsersWidget> {
  @override
  void initState() {
    super.initState();
    widget.onFabPressed.addListener(onFabPressed);
  }

  void onFabPressed() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    widget.onFabPressed.removeListener(onFabPressed);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.randomUserService.getUsers(50).catchError((err) => {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(err),
            ))
          }),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        if (snapshot.hasError)
          return Center(child: Text("Failed to load users"));

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView(
              children: snapshot.data
                  .map((user) => buildUserCard(context, user))
                  .toList());
        }
      },
    );
  }
}
