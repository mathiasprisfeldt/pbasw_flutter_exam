import 'package:flutter/material.dart';
import 'package:pbasw_flutter_exam/TabsWidget.dart';
import 'package:pbasw_flutter_exam/builders/UserCard.dart';
import 'package:pbasw_flutter_exam/types/User.dart';
import 'package:pbasw_flutter_exam/services/RandomUserService.dart';

class RandomUsersWidget extends TabPageWidget {
  final RandomUserService randomUserService = RandomUserService();

  RandomUsersWidget({Key key}) : super(key: key);

  @override
  _RandomUsersWidgetState createState() => _RandomUsersWidgetState();
}

class _RandomUsersWidgetState extends State<RandomUsersWidget> {
  static const _amountOfUsers = 50;

  GlobalKey<RefreshIndicatorState> _ind;

  @override
  void initState() {
    super.initState();
    if (widget.randomUserService.recentUsers == null) onRefreshed();
  }

  Future onRefreshed() {
    return widget.randomUserService
        .updateRecentUsers(_amountOfUsers)
        .whenComplete(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.randomUserService.recentUsers?.catchError((err) => {
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
          return RefreshIndicator(
            key: _ind,
            onRefresh: onRefreshed,
            child: ListView(
                children: snapshot.data
                    .map((user) => buildUserCard(context, user))
                    .toList()),
          );
        }
      },
    );
  }
}
