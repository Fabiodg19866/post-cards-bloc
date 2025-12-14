
import 'package:dartz/dartz.dart';
import 'package:post_cards/core/error/failures.dart';
import 'package:post_cards/core/use_case/use_case.dart';
import 'package:post_cards/features/posts/domain/entities/post.dart';
import 'package:post_cards/features/posts/domain/repositories/post_repository.dart';


class SearchPosts implements UseCase<List<Post>, SearchParams> {
  final PostRepository repository;

  SearchPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(SearchParams params) async {
    return await repository.searchPosts(params.query);
  }
}

class SearchParams {
  final String query;

  const SearchParams({required this.query});
}