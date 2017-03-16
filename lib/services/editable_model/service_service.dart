part of editable_model_service;

@Injectable()
class ServiceService extends EditableModelService
{
  ServiceService() : super("services");

  @override
  Service createModelInstance(Map<String, dynamic> data)
  {
    return new Service.decode(data);
  }
}