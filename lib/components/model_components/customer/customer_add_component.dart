// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show CustomerService, PhraseService, Customer;
import 'package:bokain_admin/components/model_components/customer/customer_details_component.dart';

@Component(
    selector: 'bo-customer-add',
    styleUrls: const ['customer_add_component.css'],
    templateUrl: 'customer_add_component.html',
    directives: const [materialDirectives, CustomerDetailsComponent],
    preserveWhitespace: false
)
class CustomerAddComponent implements OnDestroy
{
  CustomerAddComponent(this.customerService, this.phrase)
  {
    customer = new Customer(null);
  }

  void ngOnDestroy()
  {
    _onPushController.close();
  }

  Future push() async
  {
    String id = await customerService.push(customer);
    _onPushController.add(id);
  }

  @Output('push')
  Stream<String> get onPush => _onPushController.stream;

  Customer customer;
  final CustomerService customerService;
  final PhraseService phrase;

  final StreamController<String> _onPushController = new StreamController();
}
