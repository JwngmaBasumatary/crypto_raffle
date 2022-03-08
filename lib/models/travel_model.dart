class HomeCarouselModel {
  final String name;
  final String location;
  final String url;

  HomeCarouselModel({this.name, this.location, this.url});

  static List<HomeCarouselModel> generateTravelBlogs() {
    return [
      HomeCarouselModel(
          name: "Try Now and Earn Big",
          location: "Delhi",
          url:
              "https://st3.depositphotos.com/3645435/12570/v/950/depositphotos_125706784-stock-illustration-lottery-realistic-banner.jpg"),
      HomeCarouselModel(
          name: "The Best Lucky Draw",
          location: "Hongkong",
          url:
              "https://image.shutterstock.com/image-illustration/internet-raffle-roulette-fortune-banner-260nw-1381387337.jpg"),
      HomeCarouselModel(
          name: "Free And Fair Draw",
          location: "Mumbai",
          url:
              "https://png.pngtree.com/thumb_back/fw800/back_our/20190621/ourmid/pngtree-lucky-big-turntable-lottery-banner-poster-background-image_184417.jpg"),
      HomeCarouselModel(
          name: "Our Events are 100% Fair",
          location: "China",
          url:
              "https://image.shutterstock.com/image-illustration/internet-raffle-roulette-fortune-banner-260nw-1381387337.jpg"),
      HomeCarouselModel(
          name: "Instant Payment to Coinbase",
          location: "Usa",
          url:
              "https://previews.123rf.com/images/siberianart/siberianart2006/siberianart200600065/148707182-lottery-typography-vector-banner-template-raffle-drum-full-of-lottery-tickets-man-giving-gift-box-to.jpg"),
      HomeCarouselModel(
          name: "Learn how to use the app",
          location: "Amteka",
          url:
              "https://image.shutterstock.com/image-vector/lottery-banners-realistic-icons-balls-260nw-775566865.jpg"),
    ];
  }
}
