part of editable_model_service;

@Injectable()
class SalonService extends EditableModelService
{
  SalonService() : super("salons");

  @override
  _createModelInstance(String key, Map<String, String> data)
  {
    modelMap[key] = new Salon.decode(data);
  }
}