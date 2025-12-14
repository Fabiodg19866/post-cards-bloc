import 'package:dartz/dartz.dart';
import 'package:post_cards/core/error/failures.dart';
import 'package:post_cards/core/use_case/use_case.dart';
import 'package:post_cards/features/posts/domain/entities/post.dart';
import 'package:post_cards/features/posts/domain/repositories/post_repository.dart';


class GetPosts implements UseCase<List<Post>, NoParams> {
  final PostRepository repository;

  GetPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) async {
    return await repository.getPosts();
  }
}