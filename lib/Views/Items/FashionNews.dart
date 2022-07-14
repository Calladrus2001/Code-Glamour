import 'package:code_glamour/Models/NewsModel.dart';
import 'package:code_glamour/Services/NewsService.dart';
import 'package:code_glamour/constants.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

late News _news;

class _NewsPageState extends State<NewsPage> {
  bool haveData = false;

  getData() async {
    _news = (await NewsService().getNews())!;
    if (_news != null) {
      setState(() {
        haveData = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: haveData
          ? PageView.builder(
              itemCount: _news.articles!.length,
              itemBuilder: (context, int index) {
                return Column(
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        child: Image(
                          image: NetworkImage(
                              "${_news.articles![index].urlToImage}"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Chip(
                          elevation: 4.0,
                          backgroundColor: clr1,
                          label: Text(
                            "Source: ${_news.articles![index].source!.name}",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("${_news.articles![index].title}",
                            style: TextStyle(color: clr1, fontSize: 22)),
                      ),
                    ),
                    SizedBox(height: 48),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "${_news.articles![index].content}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(child: SizedBox(height: 1)),
                    Chip(
                        elevation: 4.0,
                        label: Text(
                          "${index + 1}/${_news.articles!.length}",
                          style: TextStyle(fontWeight: FontWeight.w300),
                        )),
                    SizedBox(height: 20),
                  ],
                );
              })
          : Center(child: CircularProgressIndicator(color: clr1)),
    );
  }
}
