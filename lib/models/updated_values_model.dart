class UpdatedValuesModel {
  int points;
  int clicksLeft;
  int basicScratchLeft;
  int silverScratchLeft;
  int goldScratchLeft;
  int ticTacToeLeft;
  int mindGameLeft;

  UpdatedValuesModel({
    this.points,
    this.clicksLeft,
    this.basicScratchLeft,
    this.silverScratchLeft,
    this.goldScratchLeft,
    this.ticTacToeLeft,
    this.mindGameLeft,
  });

  UpdatedValuesModel.fromJson(Map<String, dynamic> json) {
    points = json['points'];
    clicksLeft = json['clicks_left'];
    basicScratchLeft = json['basicScratchLeft'];
    silverScratchLeft = json['silverScratchLeft'];
    goldScratchLeft = json['goldScratchLeft'];
    ticTacToeLeft = json['ticTacToeLeft'];
    mindGameLeft = json['mindGameLeft'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['points'] = points;
    data['clicks_left'] = clicksLeft;
    data['basicScratchLeft'] = basicScratchLeft;
    data['silverScratchLeft'] = silverScratchLeft;
    data['goldScratchLeft'] = goldScratchLeft;
    data['ticTacToeLeft'] = ticTacToeLeft;
    data['mindGameLeft'] = mindGameLeft;

    return data;
  }
}
