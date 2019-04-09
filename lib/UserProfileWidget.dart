import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbasw_flutter_exam/services/UserService.dart';
import 'package:pbasw_flutter_exam/types/User.dart';

class UserProfileWidget extends StatefulWidget {
  final UserService userService = UserService();
  final String userID;

  UserProfileWidget({Key key, this.userID}) : super(key: key);

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat dateFormatter = DateFormat("dd/MM/yyyy");

  User user = User.empty();

  DateTime _birthDate;
  TextEditingController _birthDateField = TextEditingController();

  // Focus nodes
  FocusNode lastNameNode = FocusNode();
  FocusNode birthDateNode = FocusNode();
  FocusNode computerNode = FocusNode();

  Future<void> _submitFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var title = widget.userID != null ? "Edit User" : "New User";
    var submitText = widget.userID != null ? "Edit" : "Create";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: SingleChildScrollView(
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
                              FocusScope.of(context)
                                  .requestFocus(birthDateNode);
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
                        var newDate = dateFormatter.parse(value);

                        _birthDate = newDate;
                        _birthDateField.text = dateFormatter.format(newDate);

                        user.dob.date = newDate;
                        user.dob.age = DateTime.now().year - newDate.year;
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
                    textInputAction: TextInputAction.done,
                    focusNode: computerNode,
                    decoration: InputDecoration(
                        labelText: "Computer",
                        hintText: "Ex. MacBook Pro 2019"),
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
        ),
      ),
    );
  }

  void onSubmitPressed(BuildContext context) {
    if (_formKey.currentState.validate()) {
      Navigator.pop(context);
      setState(() {
        _submitFuture = widget.userService.updateUser(widget.userID, user);
      });
    }
  }

  void _selectDate(BuildContext context) async {
    var isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    FocusScope.of(context).requestFocus(new FocusNode());

    if (isKeyboardOpen) await Future.delayed(Duration(milliseconds: 300));

    var newDate = await showDatePicker(
      context: context,
      firstDate: DateTime(0),
      initialDate: _birthDate ?? DateTime.now(),
      lastDate: DateTime.now(),
    );

    if (newDate == null) return;

    setState(() {
      _birthDate = newDate;
      _birthDateField.text = dateFormatter.format(newDate);
      _formKey.currentState.validate();
    });
  }
}
