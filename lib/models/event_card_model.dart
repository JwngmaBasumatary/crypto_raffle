import 'package:flutter/cupertino.dart';

class EventCardModel {
  final String cryptoName;
  final int entryFee;
  final double winnerPrize;
  final String imageUrl;
  final String coinSymbol;
  final Color color;

  EventCardModel(this.cryptoName, this.entryFee, this.winnerPrize,
      this.imageUrl, this.coinSymbol, this.color);

  static List<EventCardModel> cryptoList = [
    EventCardModel(
        "Shiba Inu",
        1,
        100.0,
        "https://cryptologos.cc/logos/shiba-inu-shib-logo.png?v=014",
        "SHIB",
        const Color(0xffff6968)),
    EventCardModel(
        "Bitcoin Cash",
        1,
        0.0000100,
        "https://cryptologos.cc/logos/bitcoin-cash-bch-logo.png?v=014",
        "BCH",
        const Color(0xff7a54ff)),
    EventCardModel(
        "Cardano",
        1,
        0.01,
        "https://cryptologos.cc/logos/cardano-ada-logo.png?v=014",
        "ADA",
        const Color(0xffff8f61)),
    EventCardModel(
        "Ethereum",
        1,
        0.00001,
        "https://cryptologos.cc/logos/ethereum-eth-logo.png?v=014",
        "ETH",
        const Color(0xff2ac3ff)),
  ];
}
