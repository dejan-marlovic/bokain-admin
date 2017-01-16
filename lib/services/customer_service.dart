import 'dart:async';
import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:bokain_models/bokain_models.dart' show Customer;

@Injectable()
class CustomerService
{
  CustomerService();


  Future writeCustomerData(Customer c) async
  {
    firebase.database().ref('customers/' + c.id).set(c.properties);
  }

/*
  Stream<Customer> fetch()
  {



  }
*/


}