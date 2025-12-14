import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_cards/presentation/bloc/post/post_bloc.dart';
import 'package:post_cards/presentation/bloc/post/post_event.dart';
import 'package:post_cards/presentation/bloc/post/post_state.dart';
import 'package:post_cards/presentation/widget/post_card.dart';
import 'package:post_cards/presentation/widget/search_bar.dart';

class PostList extends StatefulWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(GetPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SearchBarWidget(
            onSearch: (query) {
              context.read<PostBloc>().add(SearchPostsEvent(query));
            },
            onClear: () {
              context.read<PostBloc>().add(ClearSearchEvent());
            },
          ),
          Expanded(
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is PostLoading || state is PostSearching) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PostLoaded) {
                  return _buildPostsList(state.posts);
                } else if (state is PostSearchLoaded) {
                  return _buildPostsList(state.posts);
                } else if (state is PostError) {
                  return _buildErrorWidget(state.message);
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsList(List posts) {
    if (posts.isEmpty) {
      return const Center(
        child: Text('No posts available'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PostBloc>().add(GetPostsEvent());
      },
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostCard(post: posts[index]);
        },
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            message == 'No posts found'
                ? Icons.search_off
                : Icons.error_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<PostBloc>().add(GetPostsEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}