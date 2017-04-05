part of model_service;

@Injectable()
class CustomerService extends ModelService
{
  CustomerService() : super("customers");

  @override
  Customer createModelInstance(Map<String, dynamic> data)
  {
    return new Customer.decode(data);
  }

  Future patchBookings(String customer_id, List<String> booking_ids) async
  {
    _loading = true;
    await _ref.child(customer_id).child("booking_ids").set(booking_ids);
    _loading = false;
  }
}