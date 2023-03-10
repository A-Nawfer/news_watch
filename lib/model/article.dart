import 'package:news_watch/model/source.dart';

class ArticleModel {
  final SourceModel? source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? img;
  final String? publishedAt;
  final String? content;

  ArticleModel(this.source, this.author, this.title, this.description, this.url, this.img,
      this.publishedAt, this.content);

  ArticleModel.fromJson(Map<String, dynamic> json) :
        source = SourceModel.fromJson(json["source"]),
        author = json["author"],
        title = json["title"],
        description = json["description"],
        url = json["url"],
        img = json["urlToImage"],
        publishedAt = json["publishedAt"],
        content = json["content"];
}