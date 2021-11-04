import 'package:equatable/equatable.dart';

class User extends Equatable {
  User(
      {this.givenname,
      this.familyname,
      this.street,
      this.postalcode,
      this.town,
      this.mobilenumber});
  final String? givenname;
  final String? familyname;
  final String? street;
  final String? postalcode;
  final String? town;
  final String? mobilenumber;

  factory User.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return User();
    final givenname = json['givenname'];
    final familyname = json['familyname'];
    final street = json['street'];
    final postalcode = json['postalcode'];
    final town = json['town'];
    final mobilenumber = json['mobilenumber'];
    return User(
        givenname: givenname,
        familyname: familyname,
        street: street,
        postalcode: postalcode,
        town: town,
        mobilenumber: mobilenumber);
  }

  factory User.empty() {
    return User();
  }

  Map<String, dynamic> toJson() => {
        'givenname': givenname,
        'familyname': familyname,
        'street': street,
        "postalcode": postalcode,
        "town": town,
        "mobilenumber": mobilenumber
      };

  @override
  List<Object> get props =>
      [givenname!, familyname!, street!, postalcode!, town!, mobilenumber!];
}
