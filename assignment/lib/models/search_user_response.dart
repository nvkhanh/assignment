// To parse this JSON data, do
//
//     final searchUserResponse = searchUserResponseFromJson(jsonString);
// @dart=2.9

import 'dart:convert';

SearchUserResponse searchUserResponseFromJson(String str) => SearchUserResponse.fromJson(json.decode(str));

class SearchUserResponse {
  SearchUserResponse({
    this.totalCount,
    this.incompleteResults,
    this.items,
  });

  int totalCount;
  bool incompleteResults;
  List<User> items;

  factory SearchUserResponse.fromJson(Map<String, dynamic> json) => SearchUserResponse(
    totalCount: json["total_count"],
    incompleteResults: json["incomplete_results"],
    items: List<User>.from(json["items"].map((x) => User.fromJson(x))),
  );
}

class User {
  User({
    this.login,
    this.id,
    this.avatarUrl,
    this.score,
    this.publicRepos,
    this.publicGits,
    this.followers,
    this.followings,
    this.name
  });

  String login;
  int id;
  String avatarUrl;
  double score;
  int publicRepos;
  int publicGits;
  int followers;
  int followings;
  String name;

  factory User.fromJson(Map<String, dynamic> json) => User(
    login: json["login"],
    id: json["id"],
    avatarUrl: json["avatar_url"],
    score: json["score"],
    publicRepos: json["public_repos"] ?? 0,
    publicGits: json["public_gists"] ?? 0,
    followers: json["followers"] ?? 0,
    followings: json["following"] ?? 0,
    name: json["name"] ?? "",
  );


}
