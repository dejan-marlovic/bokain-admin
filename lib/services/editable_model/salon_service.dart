part of editable_model_service;

@Injectable()
class SalonService extends EditableModelService
{
  SalonService() : super("salons");

  @override
  _setModel(String key, Map<String, dynamic> data)
  {
    modelMap[key] = new Salon.parse(data);
  }
}