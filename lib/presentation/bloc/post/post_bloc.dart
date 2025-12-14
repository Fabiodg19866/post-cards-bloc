import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_cards/core/use_case/use_case.dart';
import 'package:post_cards/features/posts/domain/use_case_post/get_post.dart';
import 'package:post_cards/features/posts/domain/use_case_search/search_post_usecase.dart';
import 'post_event.dart';
import 'post_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String NO_POSTS_FOUND = 'No posts found';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPosts getPosts;
  final SearchPosts searchPosts;

  PostBloc({
    required this.getPosts,
    required this.searchPosts,
  }) : super(PostInitial()) {
    on<GetPostsEvent>(_onGetPosts);
    on<SearchPostsEvent>(_onSearchPosts);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onGetPosts(
      GetPostsEvent event,
      Emitter<PostState> emit,
      ) async {
    emit(PostLoading());

    final failureOrPosts = await getPosts(const NoParams());

    failureOrPosts.fold(
          (failure) => emit(const PostError(message: SERVER_FAILURE_MESSAGE)),
          (posts) => emit(PostLoaded(posts: posts)),
    );
  }

  Future<void> _onSearchPosts(
      SearchPostsEvent event,
      Emitter<PostState> emit,
      ) async {
    if (event.query.isEmpty) {
      add(GetPostsEvent());
      return;
    }

    emit(PostSearching());

    final failureOrPosts = await searchPosts(SearchParams(query: event.query));

    failureOrPosts.fold(
          (failure) => emit(const PostError(message: SERVER_FAILURE_MESSAGE)),
          (posts) {
        if (posts.isEmpty) {
          emit(const PostError(message: NO_POSTS_FOUND));
        } else {
          emit(PostSearchLoaded(posts: posts));
        }
      },
    );
  }

  Future<void> _onClearSearch(
      ClearSearchEvent event,
      Emitter<PostState> emit,
      ) async {
    add(GetPostsEvent());
  }
}