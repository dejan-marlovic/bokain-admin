import 'dart:async';
import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart' as firebase;

@Injectable()
class UserService
{
  Future<String> login(String email, String password) async
  {
    String errorMessage;

    _loading = true;
    try
    {
      _user = await firebase.auth().signInWithEmailAndPassword(email, password);
      if (_user.emailVerified == false) throw new Exception("The user is not email verified");
    }
    catch (e)
    {
      errorMessage = e.toString();
      _user = null;
    }

    _loading = false;
    return errorMessage;
  }

  bool get isLoggedIn => _user != null;


  firebase.User _user;

  bool get isLoading => _loading;
  bool _loading = false;
}