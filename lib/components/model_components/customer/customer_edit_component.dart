// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_models/bokain_models.dart' show Booking, Customer, Salon, User;
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_details_component.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService, CustomerService, SalonService, UserService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-customer-edit',
    styleUrls: const ['customer_edit_component.css'],
    templateUrl: 'customer_edit_component.html',
    directives: const [materialDirectives, BookingDetailsComponent, CustomerDetailsComponent, DataTableComponent],
    preserveWhitespace: false
)

class CustomerEditComponent
{
  CustomerEditComponent(this.phrase, this.bookingService, this.salonService, this.userService, this.customerService);

  Future save() async
  {
    if (details.form.valid)
    {
      _bufferCustomer = new Customer.from(_customer);
      await customerService.set(_customer.id, _customer);
      _onSaveController.add(_customer.id);
    }
  }

  void cancel()
  {
    _customer = new Customer.from(_bufferCustomer);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  Map<String, Map<String, String>> get customerBookings
  {
    if (_customer == null) return null;
    Map<String, Map<String, String>> bookingData = bookingService.getRows(customer.bookingIds, true);
    Map<String, Map<String, String>> output = new Map();
    for (String key in bookingData.keys)
    {
      Booking booking = bookingService.getModel(key);
      Map<String, String> row = new Map();
      row[phrase.get(["start_time"])] = booking.strStartTime;
      row[phrase.get(["duration_minutes"])] = booking.duration.inMinutes.toString();
      row[phrase.get(["user"])] = (userService.getModel(booking.userId) as User).email;
      row[phrase.get(["salon"])] = (salonService.getModel(booking.salonId) as Salon).name;
      output[key] = row;
    }
    return output;
  }

  Customer get customer => _customer;

  @Input('model')
  void set customer(Customer value)
  {
    _customer = value;
    _bufferCustomer = new Customer.from(_customer);
  }

  @Output('save')
  Stream<String> get onSave => _onSaveController.stream;

  @ViewChild('details')
  CustomerDetailsComponent details;

  Customer _customer, _bufferCustomer;
  String selectedBookingId;
  final BookingService bookingService;
  final UserService userService;
  final SalonService salonService;
  final CustomerService customerService;
  final PhraseService phrase;
  
  final StreamController<String> _onSaveController = new StreamController();
}
