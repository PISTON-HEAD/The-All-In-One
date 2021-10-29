
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_app/News/webview_news.dart';
import 'package:new_app/log%20screens/custom_widgets.dart';
import 'package:new_app/log%20screens/main_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'catnews.dart';
import 'news_model.dart';

class MyNews extends StatefulWidget {
  const MyNews({Key? key}) : super(key: key);

  @override
  _MyNewsState createState() => _MyNewsState();
}

class _MyNewsState extends State<MyNews> {

  List<newsMaker> todaysNews = <newsMaker>[];

  bool loader = true;

  List allCategories = [
    "business",
    "sports",
    "technology",
    "general",
    "health",
    "science",
    "entertainment",
  ];
  List allImages = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSz75OZZyZ4vypngDWo4nSffCZzu_l9dJksxQ&usqp=CAU",
    "https://cdn.britannica.com/51/190751-050-147B93F7/soccer-ball-goal.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT12C9L-fAiZ08TXlSn5Xx4GQrcF61GSgh6Gg&usqp=CAU",
    "https://wallpapercave.com/wp/wp2219683.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcltYQp1PdChEKndsVHZ6I5rmUY8eRs_IO3g&usqp=CAU",
    "https://image.freepik.com/free-vector/futuristic-science-lab-backround-concept_23-2148510132.jpg",
    "https://www.popsci.com/uploads/2019/10/22/AUSBJ7SDRWXMD7VXVNJASUT6ME.jpg",
  ];

  getAllNews() async {
    theNews news = theNews();
    await news.getNews();
    todaysNews = news.allnews;
    setState(() {
      loader = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllNews();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData( color: Colors. black,),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const[
              Text("Today's ",style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                fontFamily:"Merriweather",
              ),),
              Text("News",style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                color: Colors.pink,
                fontFamily:"Merriweather",
              ),),
            ],
          ),
          actions: [
            IconButton(
              onPressed: (){
                auth.signOut().whenComplete(()async{
                  SharedPreferences share = await SharedPreferences.getInstance();
                  share.setString("LoggedIn", "false");
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MainPage()));
                });
              },
              icon: Icon(Icons.account_balance_wallet_outlined),
            ),
          ],
        ),
        body: loader ? Center(
          child: Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(color: Colors.pink,),
          ),
        ) : SingleChildScrollView(
          child: Column(
            children: [
              //Categories
              Container(
                height: 70,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: ListView.builder(
                    itemCount: allCategories.length,
                    scrollDirection: Axis.horizontal,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NewsByCat(cat:allCategories[index])));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: allImages[index],
                                    width: 120,
                                    height: 60,
                                    fit: BoxFit.cover,)),
                              Container(
                                alignment: Alignment.center,
                                width: 120,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(allCategories[index],
                                  style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.7,
                                  ),),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),

              //blogs
              ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: todaysNews.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) =>
                            NewsWebViews(url: todaysNews[index].url,)));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: todaysNews[index].urlToImage,),
                            SizedBox(height: 5,),
                            Text(todaysNews[index].title, style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontFamily: "Merriweather",
                            ),),
                            SizedBox(height: 5,),
                            Text(
                              todaysNews[index].description, style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
