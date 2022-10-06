import 'package:FlutterTask/git_repo/model/github_repo_model.dart';

import 'api_response.dart';
import 'api_service.dart';

class ApiRepository {
  static const String _baseUrl = 'https://api.github.com/search/repositories';

  static final ApiService _apiService = ApiService();

  /// Api for get repo details
  static Future<ApiResponse<GitHubRepoModel>> getRepoDetails(
      String date, int page) async {
    var url = '$_baseUrl?q=created:>$date&sort=stars&order=desc&page=$page';
    try {
      var resultJson = await _apiService.getApi(url);


      return ApiResponse.completed(GitHubRepoModel.fromJson(resultJson));
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
