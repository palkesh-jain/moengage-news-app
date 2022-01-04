import 'package:flutter/material.dart';
import 'package:news_app/provider/news_provider.dart';
import 'package:news_app/ui/news_page.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<NewsProvider>(
      create: (_) => NewsProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NewsPage(),
    );
  }
}
