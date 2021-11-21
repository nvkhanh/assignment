import 'dart:convert';
import 'dart:io';

import 'package:assignment/models/search_user_response.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  test('test parse json', () {
    final user = User.fromJson({
      "login": "nvkhanh",
      "id": 13356,
      "avatar_url": "http://test",
      "score": 1.0
    });

    expect(user.login, "nvkhanh");
    expect(user.id, 13356);
    expect(user.avatarUrl, 'http://test');
    expect(user.score, 1.0);

    final userResponse = SearchUserResponse.fromJson({
      "total_count": 1,
      "incomplete_results": false,
      "items": [
        {
          "login": "nvkhanh",
          "id": 5849339,
          "node_id": "MDQ6VXNlcjU4NDkzMzk=",
          "avatar_url": "https://avatars.githubusercontent.com/u/5849339?v=4",
          "gravatar_id": "",
          "url": "https://api.github.com/users/nvkhanh",
          "html_url": "https://github.com/nvkhanh",
          "followers_url": "https://api.github.com/users/nvkhanh/followers",
          "following_url":
          "https://api.github.com/users/nvkhanh/following{/other_user}",
          "gists_url": "https://api.github.com/users/nvkhanh/gists{/gist_id}",
          "starred_url":
          "https://api.github.com/users/nvkhanh/starred{/owner}{/repo}",
          "subscriptions_url":
          "https://api.github.com/users/nvkhanh/subscriptions",
          "organizations_url": "https://api.github.com/users/nvkhanh/orgs",
          "repos_url": "https://api.github.com/users/nvkhanh/repos",
          "events_url": "https://api.github.com/users/nvkhanh/events{/privacy}",
          "received_events_url":
          "https://api.github.com/users/nvkhanh/received_events",
          "type": "User",
          "site_admin": false,
          "score": 1.0,
          "public_repos": 5,
          "public_gists": 0,
          "followers": 30,
          "following": 0,
          "created_at": "2010-09-01T10:39:12Z",
          "updated_at": "2020-04-24T20:58:44Z"
        },
      ]
    });
    expect(userResponse.items.length, 1);
    expect(userResponse.items.first.followings, 0);
    expect(userResponse.items.first.followers, 30);
  });


  test('test parse json', () async {
    final file = File('test/test_resources/user_search_data.json').readAsStringSync();
    final userResponse = SearchUserResponse.fromJson(jsonDecode(file) as Map<String, dynamic>);
    expect(userResponse.items.length, 30);
    expect(userResponse.items.first.login,"test");

  });

}
