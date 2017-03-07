part of editable_model_service;

@Injectable()
class CustomerService extends EditableModelService
{
  CustomerService() : super("customers");

  @override
  _createModelInstance(String key, Map<String, String> data)
  {
    modelMap[key] = new Customer.decode(data);
  }
}