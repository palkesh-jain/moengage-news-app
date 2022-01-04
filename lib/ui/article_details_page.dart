import 'package:flutter/material.dart';
import 'package:news_app/Utils.dart';
import 'package:news_app/model/news_article.dart';

class ArticleDetailsPage extends StatefulWidget {
  final NewsArticle article;

  const ArticleDetailsPage(this.article, {Key? key}) : super(key: key);

  @override
  _ArticleDetailsPageState createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Article")),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: ListView(
            children: [
              Text(widget.article.title ?? "<N/A>",
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 4),
              Text(
                  "Published at ${Utils.formatDateAndTimeFromISO(widget.article.publishedAt)}",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              const SizedBox(height: 10),
              Image.network(widget.article.urlToImage ?? "",
                  loadingBuilder: (ctx, child, progress) {
                if (progress == null) return child;
                return Center(
                  child: Container(
                      height: 200, width: 400, color: Colors.grey.shade200),
                );
              }, errorBuilder: (ctx, obj, st) {
                return Center(
                  child: Container(
                      height: 200, width: 400, color: Colors.grey.shade200),
                );
              }),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Source: ${widget.article.source?.name ?? "N/a"}"),
                Text("Author: ${widget.article.author ?? "N/a"}")
              ]),
              const SizedBox(height: 10),
              Text(
                widget.article.content ?? "<N/A>",
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
