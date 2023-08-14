import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

final box = GetStorage();

signInStorage(AuthCredential credential) {
  box.write('token', credential.accessToken);
  box.write('isLogin', true);
}

signOutStorage() {
  box.remove('token');
  box.write('isLogin', false);
}
