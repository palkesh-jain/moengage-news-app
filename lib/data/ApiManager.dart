import 'dart:convert';

import 'package:news_app/model/news_article.dart';
import 'package:http/http.dart' as http;

class ApiManager {

  static Future<List<NewsArticle>> fetchNewsList() async {
    List<NewsArticle> newsList = [];
    final response = await http.get(Uri.parse(
        'https://candidate-test-data-moengage.s3.amazonaws.com/Android/news-api-feed/staticResponse.json'));
    if (response.statusCode == 200) {
      jsonDecode(response.body)["articles"].forEach((element) {
        NewsArticle article = NewsArticle.fromJson(element);
        newsList.add(article);
      });
      return newsList;
    } else {
      throw Exception("Error in Api, show offline articles");
    }
  }

}