part of model_service;

@Injectable()
class ServiceService extends ModelService
{
  ServiceService() : super("services");

  @override
  Service createModelInstance(String id, Map<String, dynamic> data)
  {
    return new Service.decode(id, data);
  }

  Future patchUsers(String service_id, List<String> user_ids) async
  {
    _loading = true;
    await _ref.child(service_id).child("user_ids").set(user_ids);
    _loading = false;
  }
}