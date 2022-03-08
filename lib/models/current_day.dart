class CurrentDay {
  String id;
  String currentDateTime;
  String utcOffset;
  bool isDayLightSavingsTime;
  String dayOfTheWeek;
  String timeZoneName;
  int currentFileTime;
  String ordinalDate;

  CurrentDay(
      {this.id,
        this.currentDateTime,
        this.utcOffset,
        this.isDayLightSavingsTime,
        this.dayOfTheWeek,
        this.timeZoneName,
        this.currentFileTime,
        this.ordinalDate,
        });

  CurrentDay.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currentDateTime = json['currentDateTime'];
    utcOffset = json['utcOffset'];
    isDayLightSavingsTime = json['isDayLightSavingsTime'];
    dayOfTheWeek = json['dayOfTheWeek'];
    timeZoneName = json['timeZoneName'];
    currentFileTime = json['currentFileTime'];
    ordinalDate = json['ordinalDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[id] = id;
    data['currentDateTime'] = currentDateTime;
    data['utcOffset'] = utcOffset;
    data['isDayLightSavingsTime'] = isDayLightSavingsTime;
    data['dayOfTheWeek'] = dayOfTheWeek;
    data['timeZoneName'] = timeZoneName;
    data['currentFileTime'] = currentFileTime;
    data['ordinalDate'] = ordinalDate;

    return data;
  }
}
