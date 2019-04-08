class User {
  Name name;
  DOB dob;
  Picture picture;
  String phone;
  String computer;

  User(DOB dob, Picture picture, String phone, String computer)
      : this.dob = dob,
        this.picture = picture,
        this.phone = phone,
        this.computer = computer;

  User.fromJson(Map data)
      : this.name = Name.fromJson(data['name']),
        this.dob = DOB.fromJson(data['dob']),
        this.picture = Picture.fromJson(data['picture']),
        this.phone = data['phone'];
}

class Name {
  String title;
  String first;
  String last;

  Name({String title, String first, String last})
      : this.title = title,
        this.first = first,
        this.last = last;

  Name.fromJson(Map data) {
    this.title = data['title'];
    this.first = data['first'];
    this.last = data['last'];
  }

  String get initials => first.substring(0, 1) + last.substring(0, 1);

  String get full => "$first $last";
}

class DOB {
  DateTime date;
  int age;

  DOB({DateTime date, int age})
      : this.date = date,
        this.age = age;

  DOB.fromJson(Map data)
      : this.date = DateTime.parse(data['date']),
        this.age = data['age'];
}

class Picture {
  String large;
  String medium;
  String thumbnail;

  Picture({String large, String medium, String thumbnail})
      : this.large = large,
        this.medium = medium,
        this.thumbnail = thumbnail;

  Picture.fromJson(Map data)
      : this.large = data['large'],
        this.medium = data['medium'],
        this.thumbnail = data['thumbnail'];
}
