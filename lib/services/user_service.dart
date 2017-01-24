part of model_service;

@Injectable()
class UserService extends ModelService
{
  UserService() : super("users");

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

  @override
  Future push(User model) async
  {
    _loading = true;
    try
    {
      firebase.User user = await firebase.auth().createUserWithEmailAndPassword(model.email, model.password);
      await user.sendEmailVerification();
    } catch(e)
    {
      _loading = false;
      return e.toString();
    }
    return await super.push(model);
  }

  @override _setModel(String key, Map<String, dynamic> data)
  {
    modelMap[key] = new User.parse(data);
  }

  bool get isLoggedIn => (_currentUser != null && _currentUser.emailVerified);
  firebase.User _currentUser;
}