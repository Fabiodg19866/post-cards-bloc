import 'package:dartz/dartz.dart';
import 'package:post_cards/core/error/failures.dart';
import 'package:post_cards/features/posts/domain/entities/post.dart';


abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts();
  Future<Either<Failure, List<Post>>> searchPosts(String query);
}