class UserStream {
  int points;
  int sumTimer;
  int multiplyTimer;
  String  email;

  UserStream({
    this.points,
    this.sumTimer,
    this.multiplyTimer,
    this.email,
  });

  Map toMap(UserStream users) {
    var data = <String, dynamic>{};
    data['points'] = users.points;
    data['sumTimer'] = users.sumTimer;
    data['multiplyTimer'] = users.multiplyTimer;
    data['email'] = users.email;

    return data;
  }

  UserStream.fromMap(Map<String, dynamic> mapData) {
    points = mapData['points'];
    sumTimer = mapData['sumTimer'];
    multiplyTimer = mapData['multiplyTimer'];
    email = mapData['email'];
  }
}
