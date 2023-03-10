import 'package:flutter/material.dart';
import 'package:news_watch/bloc/get_latest_bloc.dart';
import 'package:news_watch/elements/error_element.dart';
import 'package:news_watch/elements/loader_element.dart';
import 'package:news_watch/model/article.dart';
import 'package:news_watch/model/article_response.dart';
import 'package:news_watch/screens/news_details.dart';
import 'package:news_watch/style/theme.dart' as style;
import 'package:timeago/timeago.dart' as timeago;

class HotNews extends StatefulWidget {
  const HotNews({Key? key}) : super(key: key);

  @override
  State<HotNews> createState() => _HotNewsState();
}

class _HotNewsState extends State<HotNews> {
  @override
  void initState() {
    super.initState();
    getHotNewsBloc.getHotNews();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream: getHotNewsBloc.subject.stream,
      builder: (context, AsyncSnapshot<ArticleResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.error != null && snapshot.data!.error.isNotEmpty) {
            return Container();
          }
          return _buildHotNews(snapshot.requireData);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error.toString());
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildHotNews(ArticleResponse data) {
    List<ArticleModel> articles = data.articles;

    if(articles.isEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text("No more news",
              style: TextStyle(color: Colors.black45),
            )
          ],
        ),
      );
    } else {
      return Container(
        height: articles.length/2*210.0,
        padding: const EdgeInsets.all(5.0),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: articles.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            childAspectRatio: 0.85
          ),
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(
                  left: 5.0,
                  right: 5.0,
                  top: 10.0
                ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetails(article: articles[index],)));
                },
                child: Container(
                  width: 220.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                        spreadRadius: .50,
                        offset: Offset(1.0, 1.0)
                      )
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 16/9,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0)
                            ),
                            image: DecorationImage(
                              image: articles[index].img == null ? const AssetImage("assets/placeholder.png") as ImageProvider : NetworkImage(
                                  articles[index].img.toString()),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 15.0,
                          bottom: 15.0
                        ),
                        child: Text(
                          articles[index].title.toString(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(
                            height: 1.3,
                            fontSize: 15.0
                          ),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0
                            ),
                            width: 180,
                            height: 1.0,
                            color: Colors.black12,
                          ),
                          Container(
                            width: 30.0,
                            height: 3.0,
                            color: style.Colors.mainColor,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: Text(
                                  articles[index].source!.name.toString(),
                                  style: const TextStyle(
                                      color: style.Colors.mainColor,
                                      fontSize: 9.0
                                  ),
                                ),
                            ),
                            Flexible(
                              child: Text(
                                timeUntil(DateTime.parse(articles[index].publishedAt.toString())),
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 9.0
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
