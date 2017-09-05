// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_calendar/bokain_calendar.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/journal_component/journal_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_details_component.dart';

@Component(
    selector: 'bo-customer-edit',
    styleUrls: const ['customer_edit_component.css'],
    templateUrl: 'customer_edit_component.html',
    directives: const
    [
      BookingDetailsComponent,
      CORE_DIRECTIVES,
      CustomerDetailsComponent,
      DataTableComponent,
      JournalComponent,
      materialDirectives
    ],
    pipes: const [AsyncPipe, PhrasePipe],
    providers: const []
)

class CustomerEditComponent implements OnChanges, OnDestroy
{
  CustomerEditComponent(this.bookingService, this.customerService);

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("customer") && customer?.id != null)
    {
      bookingService.streamAll(new FirebaseQueryParams(searchProperty: "customer_id", searchValue: customer.id));
    }
  }

  void ngOnDestroy()
  {
    _onSaveController.close();
  }

  Future save() async
  {
    await customerService.set(customer.id, customer);
    _onSaveController.add(customer.id);
  }

  Future cancel() async
  {
    customer = await customerService.fetch(customer?.id, force: true);
    customerService.streamedModels[customer.id] = customer;
  }

  String selectedBookingId;
  final BookingService bookingService;
  final CustomerService customerService;
  final StreamController<String> _onSaveController = new StreamController();

  @Input('customer')
  Customer customer;

  @Output('save')
  Stream<String> get onSave => _onSaveController.stream;
}
