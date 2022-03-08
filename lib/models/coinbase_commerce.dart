class CoinbaseCommerce {
  String? code;
  String? createdAt;
  String? expiresAt;
  String? hostedUrl;
  String? id;
  Metadata? metadata;
  String? name;
  Pricing? pricing;

  CoinbaseCommerce(
      {required this.code,
      required this.createdAt,
      required this.expiresAt,
      required this.hostedUrl,
      required this.id,
      required this.metadata,
      required this.name,
      required this.pricing});

  CoinbaseCommerce.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    createdAt = json['created_at'];
    expiresAt = json['expires_at'];
    hostedUrl = json['hosted_url'];
    id = json['id'];
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    name = json['name'];
    pricing =
        json['pricing'] != null ? Pricing.fromJson(json['pricing']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['created_at'] = createdAt;
    data['expires_at'] = expiresAt;
    data['hosted_url'] = hostedUrl;
    data['id'] = id;
    if (metadata != null) {
      data['metadata'] = metadata?.toJson();
    }
    data['name'] = name;
    if (pricing != null) {
      data['pricing'] = pricing?.toJson();
    }
    return data;
  }
}

class Metadata {
  String? uid;
  String? user;
  String? email;
  String? title;
  String? eventId;
  String? luckyNumber;
  String? date;

  Metadata(
      {required this.uid,
      required this.user,
      required this.email,
      required this.title,
      required this.eventId,
      required this.luckyNumber,
      required this.date});

  Metadata.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    user = json['user'];
    email = json['email'];
    title = json['title'];
    eventId = json['eventId'];
    luckyNumber = json['luckyNumber'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['user'] = user;
    data['email'] = email;
    data['title'] = title;
    data['eventId'] = eventId;
    data['luckyNumber'] = luckyNumber;
    data['date'] = date;
    return data;
  }
}

class Pricing {
  String? amount;
  String? currency;

  Pricing({required this.amount, required this.currency});

  Pricing.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currency'] = currency;
    return data;
  }
}
