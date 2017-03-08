part of editable_model_service;

@Injectable()
class ServiceService extends EditableModelService
{
  ServiceService() : super("services");

  @override
  _createModelInstance(String key, Map<String, String> data)
  {
    modelMap[key] = new Service.decode(data);
  }
}