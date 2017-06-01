// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_models/bokain_models.dart' show BookingService, CustomerService, SalonService, UserService, Customer;
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/journal_component/journal_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_details_component.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';

@Component(
    selector: 'bo-customer-edit',
    styleUrls: const ['customer_edit_component.css'],
    templateUrl: 'customer_edit_component.html',
    directives: const [materialDirectives, BookingDetailsComponent, CustomerDetailsComponent, DataTableComponent, JournalComponent],
    pipes: const [PhrasePipe]
)

class CustomerEditComponent implements OnDestroy
{
  CustomerEditComponent(this.bookingService, this.salonService, this.userService, this.customerService);

  void ngOnDestroy()
  {
    _onSaveController.close();
  }

  Future save() async
  {
    if (details.form.valid)
    {
      await customerService.set(_customer.id, _customer);
      _onSaveController.add(_customer.id);
    }
  }

  void cancel()
  {
    //print(customer);
    if (_customer != null) _customer = new Customer.from(customerService.getModel(_customer.id));

  }

  Customer get customer => _customer;

  @Input('model')
  void set customer(Customer value)
  {
    _customer = (value == null) ? null : new Customer.from(value);
  }

  @Output('save')
  Stream<String> get onSave => _onSaveController.stream;

  @ViewChild('details')
  CustomerDetailsComponent details;

  Customer _customer;
  String selectedBookingId;
  final BookingService bookingService;
  final CustomerService customerService;
  final SalonService salonService;
  final UserService userService;
  final StreamController<String> _onSaveController = new StreamController();
}
