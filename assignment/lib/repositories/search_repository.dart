import 'package:assignment/models/search_user_response.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:http/http.dart' as http;
class SearchRepository {
  static String baseURL = "https://api.github.com/";
  Client client;
  SearchRepository(this.client);

  Future<SearchUserResponse> searchUser(String searchText) async {
    var apiFullPath = baseURL + "search/users?q=$searchText";
    final http.Response response = await client.get(apiFullPath);
    if (response.statusCode == 200) {
      return SearchUserResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('An error occurred while connecting to server');
    }
  }
  Future<User> getUserProfile(String username) async {
    var apiFullPath = baseURL + "users/$username";
    final http.Response response = await client.get(apiFullPath);
    if (response != null && response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('An error occurred while connecting to server');
    }
  }
}
