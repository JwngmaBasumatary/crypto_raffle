class Users {
  String uid;
  String name;
  String country;
  int points;
  String email;
  String profilePhoto;
  String idToken;
  int claimed;
  int earnedByReferral;
  String createdOn;
  String lastLogin;
  String referralId;
  String referredBy;
  int today;

  Users(
      {this.uid,
        this.name,
        this.country,
        this.idToken,
        this.email,
        this.points,
        this.profilePhoto,
        this.claimed,
        this.earnedByReferral,
        this.createdOn,
        this.lastLogin,
        this.referralId,
        this.referredBy,
        this.today,


      });

  Map toMap(Users users) {
    var data = <String, dynamic>{};
    data['uid'] = users.uid;
    data['name'] = users.name;
    data['country'] = users.country;
    data['email'] = users.email;
    data['idToken'] = users.idToken;
    data['points'] = users.points;
    data['profilePhoto'] = users.profilePhoto;
    data['claimed'] = users.claimed;
    data['earnedByReferral'] = users.earnedByReferral;
    data['createdOn'] = users.createdOn;
    data['lastLogin'] = users.lastLogin;
    data['referralId'] = users.referralId;
    data['referredBy'] = users.referredBy;
    data['today'] = users.today;

    return data;
  }

  Users.fromMap(Map<String, dynamic> mapData) {
    uid = mapData['uid'];
    name = mapData['name'];
    country = mapData['country'];
    email = mapData['email'];
    idToken = mapData['idToken'];
    points = mapData['points'];
    profilePhoto = mapData['profilePhoto'];
    claimed = mapData['claimed'];
    earnedByReferral = mapData['earnedByReferral'];
    createdOn = mapData['createdOn'];
    lastLogin = mapData['lastLogin'];
    referralId = mapData['referralId'];
    referredBy = mapData['referredBy'];
    today = mapData['today'];
  }
}
