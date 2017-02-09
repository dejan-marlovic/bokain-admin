part of editable_model_service;

@Injectable()
class CustomerService extends EditableModelService
{
  CustomerService() : super("customers");

  @override
  _setModel(String key, Map<String, dynamic> data)
  {
    modelMap[key] = new Customer.parse(data);
  }
}