import 'package:dio/dio.dart';
import 'package:post_cards/core/error/exceptions.dart';
import 'package:post_cards/features/posts/data/models/post.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();
  Future<List<PostModel>> searchPosts(String query);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final Dio dio;

  PostRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/posts',
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => PostModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<PostModel>> searchPosts(String query) async {
    try {
      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/posts',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        final posts = jsonList.map((json) => PostModel.fromJson(json)).toList();

        return posts.where((post) {
          final titleMatch = post.title.toLowerCase().contains(query.toLowerCase());
          final bodyMatch = post.body.toLowerCase().contains(query.toLowerCase());
          return titleMatch || bodyMatch;
        }).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}