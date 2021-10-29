import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_app/News/webview_news.dart';
import 'package:new_app/log%20screens/custom_widgets.dart';

import 'news_model.dart';

class NewsByCat extends StatefulWidget {
  final String cat;
  const NewsByCat({Key? key, required this.cat}) : super(key: key);

  @override
  _NewsByCatState createState() => _NewsByCatState();
}

class _NewsByCatState extends State<NewsByCat> {

  List<newsMaker>getCatNews = <newsMaker>[];
  bool loader  =  true;

  getAllNews()async{
    CategoryNews categoryNews = CategoryNews();
    await categoryNews.getNews(widget.cat);
    getCatNews = categoryNews.news;
    setState(() {
      loader = false;
    });
    print(getCatNews[0].title);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllNews();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(),
        body:loader ?Center(
          child: Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(color: Colors.pink,strokeWidth: 2,),
          ),
        ): SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: getCatNews.length,
              itemBuilder: (context, index){
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewsWebViews(url: getCatNews[index].url)));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: getCatNews[index].urlToImage,),
                    SizedBox(height: 5,),
                    Text(getCatNews[index].title, style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontFamily: "Merriweather",
                    ),),
                    SizedBox(height: 5,),
                    Text(
                      getCatNews[index].description, style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
