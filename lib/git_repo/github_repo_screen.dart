import 'package:FlutterTask/git_repo/view_model/git_repo_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/github_repo_model.dart';

class GithubRepoScreen extends StatelessWidget {
  GithubRepoScreen({Key? key}) : super(key: key);

  bool _isFirstLoadCompleted = false;
  int _page = 1;

  late GitRepoViewModel gitRepoViewModel;
  late ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    _scrollController = ScrollController()..addListener(_loadNextPage);
    gitRepoViewModel = context.watch<GitRepoViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub repo details'),
      ),
      body: _buildBody(gitRepoViewModel),
    );
  }

  _buildBody(GitRepoViewModel gitRepoViewModel) {
    if (gitRepoViewModel.loading && !_isFirstLoadCompleted) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (gitRepoViewModel.apiError != null) {
      return Center(
        child: Text('Error : ${gitRepoViewModel.apiError?.message}'),
      );
    }

    _isFirstLoadCompleted = true;
    var items = gitRepoViewModel.gitGubRepoList;

    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: items.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (!gitRepoViewModel.hasNextData) ++index;
                  return (!gitRepoViewModel.hasNextData &&
                          index == items.length)
                      ? Container(
                          height: 50,
                          width: double.maxFinite,
                          padding: const EdgeInsets.all(10),
                          color: Colors.green,
                          child: const Center(child: Text('All data fetched')),
                        )
                      : Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildRepoDetails(items[index]),
                          ),
                        );
                })),
        if (gitRepoViewModel.loading) ...{
          const Padding(
              padding: EdgeInsets.all(10),
              child: Center(child: CircularProgressIndicator()))
        },
      ],
    );
  }

  _buildRepoDetails(Items item) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Hero(
              tag: 'profile', child: Image.network(item.owner!.avatarUrl!)),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name ?? 'Na',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                item.description ?? 'Na',
                maxLines: 4,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.star),
                        label: Text('${item.stargazersCount}')),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20, left: 5),
                      child: Text(
                        '${item.owner!.login}',
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ))
                ],
              ),
            ],
          ),
        ))
      ],
    );
  }

  _loadNextPage() {
    if (gitRepoViewModel.hasNextData &&
        _isFirstLoadCompleted &&
        !gitRepoViewModel.loading &&
        _scrollController.position.extentAfter < 300) {
      gitRepoViewModel.getGithubRepoDetailsNext('2022-04-29', ++_page);
    }
  }
}
