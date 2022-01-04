import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_app/data/ApiManager.dart';
import 'package:news_app/model/news_article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsProvider with ChangeNotifier {
  List<NewsArticle> newsList = [];
  List<NewsArticle> offlineArticles = [];
  late SharedPreferences prefs;

  bool offlineMode = false;

  Future<void> fetchNews() async {
    newsList = await ApiManager.fetchNewsList().catchError((e) {
      throw Exception("Error in Api, show offline articles");
    });

    newsList.sort((NewsArticle a, NewsArticle b) {
      return a.publishedAt?.compareTo(b.publishedAt ?? "") ?? 0;
    });
    notifyListeners();
  }

  updateOfflineStatusOfArticles() {
    for (var element in newsList) {
      element.availableOffline = offlineArticles
          .where((offLineElement) => offLineElement.title == element.title)
          .isNotEmpty;
    }
    notifyListeners();
  }

  enableOfflineMode() {
    offlineMode = true;
    notifyListeners();
  }

  Future<void> initOfflineArticles() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("offline_articles");
    if (data != null && data.isNotEmpty) {
      jsonDecode(data).forEach((element) {
        offlineArticles.add(NewsArticle.fromJson(element));
      });
    }
    updateOfflineStatusOfArticles();
  }

  void saveArticleOffline(NewsArticle article) async {
    offlineArticles.add(article);
    article.availableOffline = true;
    prefs.setString("offline_articles", jsonEncode(offlineArticles));
    notifyListeners();
  }

  void sortListByDate() {
    newsList = newsList.reversed.toList();
    notifyListeners();
  }
}
