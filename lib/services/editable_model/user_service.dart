part of editable_model_service;

@Injectable()
class UserService extends EditableModelService
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

  @override
  _createModelInstance(String key, Map<String, String> data)
  {
    modelMap[key] = new User.decode(data);
  }

  bool get isLoggedIn => (_currentUser != null && _currentUser.emailVerified);
  firebase.User _currentUser;
}