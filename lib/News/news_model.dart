import 'dart:convert';

import 'package:http/http.dart' as http;

class newsMaker {
  late String title;
  late String content;
  late String url;
  late String description;
  late String urlToImage;
  newsMaker(
      {required this.url,
      required this.description,
      required this.title,
      required this.urlToImage,
      required this.content,
      });
}

class theNews {
  List<newsMaker> allnews = [];
  Future<void> getNews() async {
    Uri url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=ca455f9f59da496e83d17c9ea1cedddf");
    final getter = await http.get(url);
    final jsonData = jsonDecode(getter.body);
    if (jsonData["status"] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element["description"] != null) {
          allnews.add(newsMaker(
              url: element["url"],
              description: element["description"],
              title: element["title"],
              urlToImage: element["urlToImage"],
              content: element["content"] == null ? "":element["content"],
             ));
        }
      });
    }
  }
}

class CategoryNews {
  List<newsMaker> news = [];
  Future<void> getNews(String getCategory)async{
    Uri url = Uri.parse("https://newsapi.org/v2/top-headlines?category=$getCategory&country=in&apiKey=ca455f9f59da496e83d17c9ea1cedddf");
    print(url);
    var resonse = await http.get(url);
    var jsonData = jsonDecode(resonse.body);
    if(jsonData["status"] =="ok" ){
      jsonData["articles"].forEach((element){
        if(element["urlToImage"] != null && element["description"] != null){
          newsMaker articleModel = newsMaker(
            title:  element["title"],
            description: element["description"],
            urlToImage: element["urlToImage"],
            url: element["url"],
            content: element["content"] == null ?"":element["content"],
          );
          news.add(articleModel);
        }
      });
    }
  }

}