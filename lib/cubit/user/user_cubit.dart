import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_time/services/user_service.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  User? user;
  UserCubit() : super(UserInitial()) {
    getUser();
  }

  void getUser() async {
    try {
      emit(UserLoading());
      var response = await UserService().getUser();

      if (response != null) {
        user = response;
        emit(UserLoaded(user!));
      } else {
        emit(UserError());
      }
    } on UserError {
      emit(UserError());
    }
  }
}
