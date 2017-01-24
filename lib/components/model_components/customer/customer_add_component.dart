// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library customer_add_component;

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Customer;
import 'package:bokain_admin/components/model_components/customer/customer_details_component.dart';
import 'package:bokain_admin/services/model_service.dart' show CustomerService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-customer-add',
    styleUrls: const ['add_component.css'],
    templateUrl: 'add_component.html',
    directives: const [materialDirectives, CustomerDetailsComponent],
    preserveWhitespace: false
)
class CustomerAddComponent
{
  CustomerAddComponent(this.customerService, this.phrase)
  {

  }

  /*
  Future pushIfValid() async
  {

    if (await validateUniqueFields(customer) == true)
    {
      await modelService.push(customer);
      router.navigate(['CustomerList']);
    }
  }
*/
  Customer customer = new Customer();
  final CustomerService customerService;
  final PhraseService phrase;


}
