// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show AuthService, CustomerService, MailerService, Customer;
import 'package:bokain_admin/components/model_components/customer/customer_details_component.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';

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
  CustomerAddComponent(this._authService, this.customerService, this._mailerService)
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
      customer.token = await _authService.register(customer.email, customer.firstname, customer.lastname);
      _onAddController.add(await customerService.push(customer));
      await _mailerService.mail("<h1>HEJSAN</h1><p>din token: ${customer.token}</p>", "VÄLKOMMEN", customer.email);

      customer = new Customer();
    }
    catch (e)
    {
      print(e);
      _onAddController.add(null);
    }
  }

  Customer customer;
  final AuthService _authService;
  final CustomerService customerService;
  final MailerService _mailerService;
  final StreamController<String> _onAddController = new StreamController();

  @Output('add')
  Stream<String> get onAddOutput => _onAddController.stream;
}
