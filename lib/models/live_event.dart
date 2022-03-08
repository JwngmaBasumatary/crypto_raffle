class LiveEvent {
  final String title;
  final String coin;
  final String time;
  final String status;
  final String img;
  final bool entryClosed;
  final num entryFee;
  final num winnerPrize;
  final int total;
  final int participated;
  final int eventId;
  final String symbol;
  final bool instant;
  final String hash;
  final String key;

  LiveEvent({
    this.title,
    this.coin,
    this.time,
    this.status,
    this.img,
    this.entryClosed,
    this.entryFee,
    this.winnerPrize,
    this.total,
    this.participated,
    this.eventId,
    this.symbol,
    this.instant,
    this.hash,
    this.key,
  });
}
