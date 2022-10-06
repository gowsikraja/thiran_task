import 'package:FlutterTask/git_repo/github_repo_screen.dart';
import 'package:FlutterTask/git_repo/view_model/git_repo_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => GitRepoViewModel())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Task',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GithubRepoScreen(),
      ),
    );
  }
}
