part of editable_model_service;

@Injectable()
class CustomerService extends EditableModelService
{
  CustomerService() : super("customers");

  @override
  Customer createModelInstance(Map<String, dynamic> data)
  {
    return new Customer.decode(data);
  }
}