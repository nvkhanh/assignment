import 'dart:io';

import 'package:assignment/models/search_user_response.dart';
import 'package:assignment/repositories/search_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';


class MockClient extends Mock implements http.Client {}

void main() {
  MockClient mockClient;
  SearchRepository provider;
  setUp(() {
    mockClient = MockClient();
    provider = SearchRepository(mockClient);
  });
  group('test api', () {
    test('returns an SearchUserResponse if the http call completes successfully', () async {
      final file = File('test/test_resources/one_user.json').readAsStringSync();
      when(mockClient.get(argThat(
          contains("/search/users"),
        ),headers: anyNamed('headers'),))
          .thenAnswer((_) async =>
          http.Response(file, 200, headers: {'content-type': 'application/json; charset=utf-8'}));
      var response = await provider.searchUser("test");
      expect(response, isA<SearchUserResponse>());
    });

    test('returns an UserDetail if the http call completes successfully', () async {
      final mockData = File('test/test_resources/user_detail.json').readAsStringSync();
      when(mockClient.get(argThat(
        contains("/users/"),
      ),headers: anyNamed('headers'),))
          .thenAnswer((_) async =>
          http.Response(mockData, 200, headers: {'content-type': 'application/json; charset=utf-8'}));
      var response = await provider.getUserProfile("test");
      expect(response.followers, 30);
      expect(response.followings, 0);
      expect(response.name, '');
    });

  });
}