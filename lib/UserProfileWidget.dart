import 'package:flutter/material.dart';
import 'package:pbasw_flutter_exam/services/UserService.dart';
import 'package:pbasw_flutter_exam/types/User.dart';
import 'helpers/DateHelper.dart';

class UserProfileWidget extends StatefulWidget {
  final UserService userService = UserService();

  UserProfileWidget({Key key}) : super(key: key);

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  final _formKey = GlobalKey<FormState>();

  User user = User.empty();
  bool get userExisting => user.name?.first != null;

  DateTime _birthDate;
  TextEditingController _birthDateField = TextEditingController();

  // Focus nodes
  FocusNode lastNameNode = FocusNode();
  FocusNode birthDateNode = FocusNode();
  FocusNode computerNode = FocusNode();

  bool isRequesting = false;

  @override
  Widget build(BuildContext context) {
    var existingUser = ModalRoute.of(context).settings.arguments;
    if (existingUser != null) user = existingUser;

    var title = userExisting ? "Editing ${user.name.first}" : "New User";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Builder(
          builder: (context) {
            if (!isRequesting) {
              return buildForm(context);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  SingleChildScrollView buildForm(BuildContext context) {
    var submitText = userExisting ? "Edit" : "Create";

    if (user?.dob?.date != null)
      _birthDateField.text = DateHelper.format(user.dob.date);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  /*
                      First name field
                     */
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: TextFormField(
                        initialValue: user?.name?.first,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: "First"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "First name is required";
                          } else {
                            user.name.first = value;
                          }
                        },
                        onFieldSubmitted: (res) {
                          FocusScope.of(context).requestFocus(lastNameNode);
                        },
                      ),
                    ),
                  ),
                  /*
                      Last name field
                     */
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: TextFormField(
                        initialValue: user?.name?.last,
                        textInputAction: TextInputAction.next,
                        focusNode: lastNameNode,
                        decoration: InputDecoration(labelText: "Last"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Last name is required";
                          } else {
                            user.name.last = value;
                          }
                        },
                        onFieldSubmitted: (res) {
                          FocusScope.of(context).requestFocus(birthDateNode);
                        },
                      ),
                    ),
                  )
                ],
              ),
              /*
                  Birth date Field
                 */
              TextFormField(
                textInputAction: TextInputAction.next,
                focusNode: birthDateNode,
                keyboardType: TextInputType.datetime,
                controller: _birthDateField,
                decoration: InputDecoration(
                    hintText: "Ex. 05/02/1993",
                    labelText: "Birth date",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () => _selectDate(context),
                    )),
                validator: (value) {
                  try {
                    var newDate = DateHelper.parse(value);

                    _birthDate = newDate;
                    _birthDateField.text = DateHelper.format(newDate);

                    user.dob.date = newDate;
                  } catch (e) {
                    return "Must be a valid date";
                  }
                },
                onFieldSubmitted: (res) {
                  FocusScope.of(context).requestFocus(computerNode);
                },
              ),
              /*
                  Computer field
                 */
              TextFormField(
                initialValue: user?.computer,
                textInputAction: TextInputAction.done,
                focusNode: computerNode,
                decoration: InputDecoration(
                    labelText: "Computer", hintText: "Ex. MacBook Pro 2019"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Computer must not be empty";
                  } else {
                    user.computer = value;
                  }
                },
                onFieldSubmitted: (res) => onSubmitPressed(context),
              ),
              /*
                  Submit field
                 */
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: RaisedButton(
                  child: Text(submitText),
                  onPressed: () => onSubmitPressed(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onSubmitPressed(BuildContext context) {
    if (_formKey.currentState.validate()) {
      setState(() {
        isRequesting = true;
      });

      widget.userService.updateUser(user.id, user).then((val) {
        Navigator.pop(context);
      });
    }
  }

  void _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());

    await Future.delayed(Duration(milliseconds: 100));

    var newDate = await showDatePicker(
      context: context,
      firstDate: DateTime(0),
      initialDate: _birthDate ?? DateTime.now(),
      lastDate: DateTime.now(),
    );

    if (newDate == null) return;

    setState(() {
      _birthDate = newDate;
      _birthDateField.text = DateHelper.format(newDate);
    });
  }
}
