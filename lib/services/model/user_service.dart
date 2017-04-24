part of model_service;

@Injectable()
class UserService extends ModelService
{
  UserService() : super("users")
  {
  }

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
  Future<String> push(ModelBase model) async
  {
    _loading = true;
    try
    {
      firebase.User user = await firebase.auth().createUserWithEmailAndPassword((model as User).email, (model as User).password);
      await user.sendEmailVerification();
    } catch(e)
    {
      _loading = false;
      return e.toString();
    }
    return await super.push(model);
  }

  @override
  User createModelInstance(String id, Map<String, dynamic> data)
  {
    return new User.decode(id, data);
  }

  Future patchCustomers(String user_id, List<String> customer_ids) async
  {
    _loading = true;
    await _ref.child(user_id).child("customer_ids").set(customer_ids);
    _loading = false;
  }

  Future patchSalons(String user_id, List<String> salon_ids) async
  {
    _loading = true;
    await _ref.child(user_id).child("salon_ids").set(salon_ids);
    _loading = false;
  }

  Future patchServices(String user_id, List<String> service_ids) async
  {
    _loading = true;
    await _ref.child(user_id).child("service_ids").set(service_ids);
    _loading = false;
  }

  Future patchBookings(String user_id, List<String> booking_ids) async
  {
    _loading = true;
    await _ref.child(user_id).child("booking_ids").set(booking_ids);
    _loading = false;
  }

  bool get isLoggedIn => (_currentUser != null && _currentUser.emailVerified);
  User get selectedUser => selectedModel;
  firebase.User _currentUser;
}