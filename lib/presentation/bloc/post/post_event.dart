import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class GetPostsEvent extends PostEvent {}

class SearchPostsEvent extends PostEvent {
  final String query;

  const SearchPostsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearchEvent extends PostEvent {}