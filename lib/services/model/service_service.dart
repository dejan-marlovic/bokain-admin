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
}