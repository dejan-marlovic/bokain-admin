part of editable_model_service;

@Injectable()
class ServiceService extends EditableModelService
{
  ServiceService() : super("services");

  @override
  Service createModelInstance(Map<String, String> data)
  {
    return new Service.decode(data);
  }
}