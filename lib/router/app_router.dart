import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:post_cards/core/services/auth_service.dart';
import 'package:post_cards/features/posts/domain/entities/post.dart';
import 'package:post_cards/presentation/views/post_detail.dart';
import 'package:post_cards/presentation/views/post_list.dart';

class AppRouter {
  final AuthService authService;

  AppRouter(this.authService);

  GoRouter get router => GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const PostList(),
      ),
      GoRoute(
        path: '/post/:id',
        name: 'postDetail',
        builder: (context, state) {
          final post = state.extra as Post;
          return PostDetail(post: post);
        },
        redirect: (context, state) async {
          final authenticated = await authService.authenticate();

          if (!authenticated) {
            return '/';
          }

          return null;
        },
      ),
    ],
    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
