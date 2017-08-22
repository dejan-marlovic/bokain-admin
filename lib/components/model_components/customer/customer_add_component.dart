// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/model_components/customer/customer_details_component.dart';

@Component(
    selector: 'bo-customer-add',
    styleUrls: const ['customer_add_component.css'],
    templateUrl: 'customer_add_component.html',
    directives: const [materialDirectives, CustomerDetailsComponent],
    providers: const [MailerService],
    pipes: const [PhrasePipe]
)
class CustomerAddComponent implements OnDestroy
{
  CustomerAddComponent(this.customerService, this._customerAuthService, this._errorOutputService)
  {
    customer = new Customer();
  }

  void ngOnDestroy()
  {
    _onAddController.close();
  }

  Future push() async
  {
    try
    {
      /*String token = */ await _customerAuthService.register(customer.email);
      _onAddController.add(await customerService.push(customer));
      customer = new Customer();
    }
    catch (e)
    {
      _errorOutputService.set(e.toString());
      _onAddController.add(null);
    }
  }

  Customer customer;
  final CustomerAuthService _customerAuthService;
  final CustomerService customerService;
  final ErrorOutputService _errorOutputService;
  final StreamController<String> _onAddController = new StreamController();

  @Output('add')
  Stream<String> get onAddOutput => _onAddController.stream;
}
