class EventType {
  final String? title;
  final String? img;
  final num? entryFee;
  final num? winnerPrize;
  final num? referralBonus;
  final String? eventCollectionName;
  final String? liveEventCollectionName;

  EventType(
      {this.title,
      this.img,
      this.entryFee,
      this.winnerPrize,
      this.referralBonus,
      this.eventCollectionName,
      this.liveEventCollectionName});

  static List<EventType> eventTypes = [
    EventType(
        title: "Mini Crypto Event",
        img:
            "https://cdn-az.allevents.in/events3/banners/d51d3eadbb63562c65e7648822d5e0f9ff1a7ad25f91bfb5c6588fa93d32c406-rimg-w526-h266-gmir.jpg?v=1636267403",
        entryFee: 0.00001,
        winnerPrize: 0.001,
        referralBonus: 0.0001,
        eventCollectionName: "Mini_Events",
        liveEventCollectionName: "Live_Mini_Events"),
    EventType(
        title: "Medium Crypto Event",
        img:
            "https://cdn.stayhappening.com/events1/banners/2750bf58c0a0c4133c8f8cff7600aca065b658647a17693c598f885a529f056f-rimg-w521-h296-gmir.jpg?v=1620004596",
        entryFee: 0.00001,
        winnerPrize: 0.001,
        referralBonus: 0.0001,
        eventCollectionName: "Medium_Events",
        liveEventCollectionName: "Live_Medium_Events"),
    EventType(
        title: "Mega Crypto Event",
        img:
            "https://i0.wp.com/vfxdownload.com/wp-content/uploads/2019/06/Crypto-Event-Broadcast-Pack-InlinePreview-HD-SALE2.jpg?w=590&ssl=1",
        entryFee: 0.00001,
        winnerPrize: 0.001,
        referralBonus: 0.0001,
        eventCollectionName: "Mega_Event",
        liveEventCollectionName: "Live_Mega_Events"),
  ];
}
