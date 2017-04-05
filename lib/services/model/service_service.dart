part of model_service;

@Injectable()
class ServiceService extends ModelService
{
  ServiceService() : super("services");

  @override
  Service createModelInstance(Map<String, dynamic> data)
  {
    return new Service.decode(data);
  }
}