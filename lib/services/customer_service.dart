
import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart';
import 'package:bokain_models/bokain_models.dart' show Customer;
import 'package:bokain_admin/services/model_service.dart';

@Injectable()
class CustomerService extends ModelService
{
  CustomerService() : super("customers");
}