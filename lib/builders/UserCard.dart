import 'package:flutter/material.dart';
import 'package:pbasw_flutter_exam/helpers/DateHelper.dart';
import 'package:pbasw_flutter_exam/main.dart';
import 'package:pbasw_flutter_exam/services/UserService.dart';
import 'package:pbasw_flutter_exam/types/User.dart';

const userCardAvatarRadius = 50.0;

Widget buildUserCard(BuildContext context, User user,
    {String userId, UserService userService}) {
  return Card(
    child: InkWell(
      onLongPress: userId != null
          ? () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Delete user?"),
                      content: Text(
                          "This will delete the user and is not reversible."),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("CANCEL"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text("ACCEPT"),
                          onPressed: () {
                            userService.removeUser(userId);
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            }
          : null,
      onTap: userId != null
          ? () {
              Navigator.of(context)
                  .pushNamed(userRoute, arguments: user.withId(userId));
            }
          : null,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
                backgroundImage: user.picture?.medium != null
                    ? NetworkImage(user.picture.medium)
                    : null,
                minRadius: userCardAvatarRadius,
                child: Text(user.name.initials.toLowerCase())),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildInfoLine(user.name.full, context,
                      customStyle: Theme.of(context).textTheme.title),
                  Container(
                    height: 5,
                  ),
                  Visibility(
                    child: buildInfoLine("Tel.: ${user.phone}", context),
                    visible: user.phone != null && user.phone.isNotEmpty,
                  ),
                  Visibility(
                    child: buildInfoLine(
                        "Born: ${DateHelper.format(user.dob.date)} (${user.dob.age} years old)",
                        context),
                    visible: user.dob != null && user.dob.date != null,
                  ),
                  Visibility(
                    child: buildInfoLine("Computer: ${user.computer}", context),
                    visible: user.computer != null && user.computer.isNotEmpty,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Text buildInfoLine(String info, BuildContext context, {TextStyle customStyle}) {
  var theme = Theme.of(context).textTheme;

  return Text(
    info,
    style: customStyle ?? theme.body2,
    overflow: TextOverflow.fade,
    softWrap: false,
    maxLines: 1,
  );
}
