class CoinAddressModel {
  String? coinAddress;

  CoinAddressModel({required this.coinAddress});

  CoinAddressModel.fromJson(Map<String, dynamic> json) {
    coinAddress = json['coinAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coinAddress'] = coinAddress;

    return data;
  }
}
