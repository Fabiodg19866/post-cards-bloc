import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:post_cards/core/network/network_info.dart';
import 'package:post_cards/core/services/auth_service.dart';
import 'package:post_cards/features/posts/data/data_sources/post_remote_data_source.dart';
import 'package:post_cards/features/posts/data/repositories/post_repository.dart';
import 'package:post_cards/features/posts/domain/repositories/post_repository.dart';
import 'package:post_cards/features/posts/domain/use_case_post/get_post.dart';
import 'package:post_cards/features/posts/domain/use_case_search/search_post_usecase.dart';
import 'package:post_cards/presentation/bloc/post/post_bloc.dart';


final sl = GetIt.instance;

Future<void> init() async {

  sl.registerFactory(
        () => PostBloc(
      getPosts: sl(),
      searchPosts: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetPosts(sl()));
  sl.registerLazySingleton(() => SearchPosts(sl()));

  sl.registerLazySingleton<PostRepository>(
        () => PostRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<PostRemoteDataSource>(
        () => PostRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => AuthService());

  sl.registerLazySingleton(() => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  ));
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
}