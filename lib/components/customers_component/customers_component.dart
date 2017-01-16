// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Customer;
import 'package:bokain_admin/services/customer_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-customers',
    styleUrls: const ['customers_component.css'],
    templateUrl: 'customers_component.html',
    directives: const [materialDirectives],
    preserveWhitespace: false
)

class CustomersComponent
{
  CustomersComponent(this.phrase, this.customerService)
  {
    Map<String, dynamic> data = new Map();
    data["id"] = "abc123";
    data["email"] = "patrick.minogue@gmail.com";
    data["email_shop"] = "patrick.minogue@gmail.com";
    data["phone"] = "0709145324";
    data["firstname"] = "patrick";
    data["lastname"] = "minogue";
    data["preferred_language"] = "sv";
    data["street"] = "arkitektvägen 53";
    data["postal_code"] = "12345";
    data["city"] = "Stockholm";
    Customer test = new Customer.parse(data);
    customerService.writeCustomerData(test);
  }

  final CustomerService customerService;
  final PhraseService phrase;

  List<Customer> _customers;
}
