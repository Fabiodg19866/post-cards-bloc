import 'package:dartz/dartz.dart';
import 'package:post_cards/core/error/exceptions.dart';
import 'package:post_cards/core/error/failures.dart';
import 'package:post_cards/core/network/network_info.dart';
import 'package:post_cards/features/posts/data/data_sources/post_remote_data_source.dart';
import 'package:post_cards/features/posts/domain/entities/post.dart';
import 'package:post_cards/features/posts/domain/repositories/post_repository.dart';


class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getPosts();
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> searchPosts(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.searchPosts(query);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }
}