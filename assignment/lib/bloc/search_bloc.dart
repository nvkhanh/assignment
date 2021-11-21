import 'package:assignment/models/search_user_response.dart';
import 'package:assignment/repositories/search_repository.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SearchUserEvent {}

class SearchUserRequested extends SearchUserEvent {
  SearchUserRequested(this.text);
  final String text;
}
class SearchUserClearText extends SearchUserEvent {}

class SearchUserDetailEvent extends SearchUserEvent {
  final String username;
  SearchUserDetailEvent(this.username);
}


abstract class SearchUserState {}
class SearchUserInitial extends SearchUserState {}
class SearchUserLoadInProgress extends SearchUserState {}
class SearchUserLoadFailure extends SearchUserState {}
class SearchUserLoadSuccess extends SearchUserState {
  SearchUserLoadSuccess(this.user);
  final List<User> user;
}
class SearchUserDetailSuccess extends SearchUserState {
  final User user;
  SearchUserDetailSuccess(this.user);
}


class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final SearchRepository repository;
  SearchUserBloc(this.repository) : super(SearchUserInitial()) {
    on<SearchUserRequested>((event, emit) => onSearchUserRequested(event, emit));
    on<SearchUserClearText>((event, emit) => emit(SearchUserInitial()));
    on<SearchUserDetailEvent>((event, emit) => onSearchUserDetailSuccess(event, emit));
  }

  void onSearchUserRequested(SearchUserRequested event, Emitter<SearchUserState> emit) async {
    emit(SearchUserLoadInProgress());
    try {
      final response = await repository.searchUser(event.text);
      emit(SearchUserLoadSuccess(response.items));
      } catch (_) {
        emit(SearchUserLoadFailure());
    }
  }
  void onSearchUserDetailSuccess(SearchUserDetailEvent event, Emitter<SearchUserState> emit) async {
    emit(SearchUserLoadInProgress());
    try {
      final response = await repository.getUserProfile(event.username);
      emit(SearchUserDetailSuccess(response));
    } catch (_) {
      emit(SearchUserLoadFailure());
    }
  }

}

