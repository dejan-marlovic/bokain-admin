// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent, ImageFileComponent;
import 'package:bokain_models/bokain_models.dart' show BookingService, CustomerService, JournalService, SalonService, UserService, PhraseService, Booking, Customer, JournalEntry, Salon, User;
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_details_component.dart';

@Component(
    selector: 'bo-customer-edit',
    styleUrls: const ['customer_edit_component.css'],
    templateUrl: 'customer_edit_component.html',
    directives: const [materialDirectives, BookingDetailsComponent, CustomerDetailsComponent, DataTableComponent, ImageFileComponent],
    preserveWhitespace: false
)

class CustomerEditComponent
{
  CustomerEditComponent(this.phrase, this.bookingService, this.salonService, this.userService, this.customerService, this.journalService);

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
    if (customer != null) customer = customerService.getModel(customer.id);
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

  Future addImage(String data_base64) async
  {
    bufferJournalEntry.commentsExternal;
    String filename = await journalService.uploadImage(data_base64);
    if (!bufferJournalEntry.imageFilenames.contains(filename)) bufferJournalEntry.imageFilenames.add(filename);
  }

  Future pushJournalEntry() async
  {
    String id = await journalService.push(bufferJournalEntry);

    /// TODO move to journalService.onChildAdded
    /*
    _customer.journalEntryIds.add(id);
    await customerService.patchJournalEntries(_customer);
    */
    bufferJournalEntry = new JournalEntry(_customer.id);
    journalImageCounter.clear();
  }

  Customer get customer => _customer;

  @Input('model')
  void set customer(Customer value)
  {
    _customer = (value == null) ? null : new Customer.from(value);
    bufferJournalEntry = new JournalEntry(_customer.id);
  }

  @Output('save')
  Stream<String> get onSave => _onSaveController.stream;

  @ViewChild('details')
  CustomerDetailsComponent details;

  Customer _customer;
  String selectedBookingId;
  final BookingService bookingService;
  final CustomerService customerService;
  final JournalService journalService;
  final SalonService salonService;
  final UserService userService;
  final PhraseService phrase;
  final StreamController<String> _onSaveController = new StreamController();

  JournalEntry bufferJournalEntry;

  List<int> journalImageCounter = new List();
}
