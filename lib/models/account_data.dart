class AccountData {
  String? profilePhoto;
  String? name;
  String? email;
  String? createdOn;
  String? lastLogin;

  AccountData(
      {
      required this.email,
      required this.name,
      required this.createdOn,
      required this.lastLogin,
      required this.profilePhoto});

  AccountData.fromJson(Map<String, dynamic> json) {
    profilePhoto = json['profilePhoto'];
    name = json['name'];
    email = json['email'];
    createdOn = json['createdOn'];
    lastLogin = json['lastLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profilePhoto'] = profilePhoto;
    data['name'] = name;
    data['email'] = email;
    data['createdOn'] = createdOn;
    data['lastLogin'] = lastLogin;

    return data;
  }
}
