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
      _currentUser = await firebase.auth().signInWithEmailAndPassword(email, password);
      if (_currentUser.emailVerified == false) throw new Exception("The user is not email verified");
    }
    catch (e)
    {
      errorMessage = e.toString();
      _currentUser = null;
    }
    _loading = false;
    return errorMessage;
  }

  /// Create a new user, returning a an error message if failed
  /// Possible errors: The e-mail is already registered or the password is in the wrong format
  Future<String> create(String email, String password, bool notify_email) async
  {
    _loading = true;
    try
    {
      firebase.User user = await firebase.auth().createUserWithEmailAndPassword(email, password);
      if (notify_email) await user.sendEmailVerification();
    } catch(e)
    {
      _loading = false;
      return e.toString();
    }
    _loading = false;
    return null;
  }

  bool get isLoggedIn => (_currentUser != null && _currentUser.emailVerified);

  firebase.User _currentUser;

  bool get isLoading => _loading;
  bool _loading = false;
}