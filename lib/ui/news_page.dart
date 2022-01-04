import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/Utils.dart';
import 'package:news_app/model/news_article.dart';
import 'package:news_app/provider/news_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late NewsProvider _provider;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _provider
          .fetchNews()
          .then((value) => _provider.initOfflineArticles())
          .catchError((e) {
        _provider.enableOfflineMode();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(builder: (cxt, provider, child) {
      _provider = provider;
      return Scaffold(
        appBar: AppBar(
          title: const Text("Latest News"),
          actions: [
            InkWell(
              onTap: () {
                _provider.sortListByDate();
              },
              child: Row(
                children: const [
                  Icon(Icons.sort),
                  SizedBox(width: 4),
                  Text("Sort by date"),
                  SizedBox(width: 16),
                ],
              ),
            )
          ],
        ),
        backgroundColor: Colors.grey.shade300,
        body: SafeArea(
          child: ListView.builder(
              itemBuilder: (ctx, index) {
                NewsArticle article = _provider.offlineMode
                    ? _provider.offlineArticles[index]
                    : _provider.newsList[index];
                return InkWell(
                  onTap: () {
                    launch(article.url ?? ""); // TODO: Handle null URLs
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ArticleDetailsPage(article)));
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(article.title ?? "<N/A>",
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 4),
                          Text(
                              "Published at ${Utils.formatDateAndTimeFromISO(article.publishedAt)}",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade500)),
                          const SizedBox(height: 10),
                          CachedNetworkImage(
                              imageUrl: article.urlToImage ?? "",
                              errorWidget: (context, url, extra) {
                                return Container(
                                  width: 400,
                                  height: 200,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/placeholder.png'),
                                        fit: BoxFit.cover),
                                  ),
                                );
                              },
                              placeholder: (context, url) => Container(
                                    width: 400,
                                    height: 200,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/placeholder.png'),
                                          fit: BoxFit.cover),
                                    ),
                                  )),
                          const SizedBox(height: 10),
                          Text(
                            article.description ?? "<N/A>",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Text("Source: ${article.source?.name ?? "N/a"}",
                              style: const TextStyle(fontSize: 12)),
                          Text("Author: ${article.author ?? "N/a"}",
                              style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              if (!article.availableOffline)
                                TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.grey.shade100),
                                    onPressed: () {
                                      _provider.saveArticleOffline(article);
                                    },
                                    child: const Text("Save offline")),
                              if (article.availableOffline)
                                const Text("Available offline",
                                    style: TextStyle(color: Colors.blue)),
                              const SizedBox(width: 10),
                              if (article.url != null)
                                IconButton(
                                    onPressed: () => shareArticle(article),
                                    icon: const Icon(Icons.share))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: _provider.offlineMode
                  ? _provider.offlineArticles.length
                  : _provider.newsList.length),
        ),
      );
    });
  }

  shareArticle(NewsArticle article) {
    Share.share(
        "Latest news of today!\n\n${article.title}\nRead at ${article.url}");
  }
}
