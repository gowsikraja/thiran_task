import 'package:FlutterTask/api/api_repository.dart';
import 'package:FlutterTask/api/api_response.dart';
import 'package:FlutterTask/git_repo/model/api_error_model.dart';
import 'package:FlutterTask/git_repo/model/github_repo_model.dart';
import 'package:flutter/cupertino.dart';

class GitRepoViewModel extends ChangeNotifier {
  bool _loading = false;
  ApiError? _apiError;

  final List<Items> _gubRepoList = [];

  bool _hasNextPage = true;

  String? message;

  bool get loading => _loading;

  bool get hasNextData => _hasNextPage;

  List<Items> get gitGubRepoList => _gubRepoList;

  ApiError? get apiError => _apiError;

  GitRepoViewModel() {
    getGithubRepoDetailsFirst();
  }

  setNextData(bool hasNextData) {
    _hasNextPage = hasNextData;
  }

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setGithubRepoModel(List<Items> gubRepoList) {
    _gubRepoList.addAll(gubRepoList);
  }

  setApiError(ApiError apiError) {
    _apiError = apiError;
  }

  getGithubRepoDetailsFirst() {
    getGithubRepoDetails('2022-04-29', 1);
  }

  getGithubRepoDetailsNext(String date, int page) {
    getGithubRepoDetails(date, page);
  }

  getGithubRepoDetails(String date, int page) async {
    setLoading(true);

    var response = await ApiRepository.getRepoDetails(date, page);

    if (response.status == Status.complete) {
      if (response.data?.items != null) {
        setGithubRepoModel(response.data!.items ?? []);
      } else {
        message = response.message ?? 'Empty';
        setNextData(false);
      }
    } else if (response.status == Status.error) {
      setApiError(ApiError(response.message!));
    }
    setLoading(false);
  }
}
