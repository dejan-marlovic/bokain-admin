// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of edit_component_base;

@Component(
    selector: 'bo-customer-edit',
    styleUrls: const ['../customer/customer_edit_component.css'],
    templateUrl: '../customer/customer_edit_component.html',
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
    providers: const [CustomerAuthService, JournalService]
)

class CustomerEditComponent extends EditComponentBase implements OnChanges
{
  CustomerEditComponent(
      this.bookingService,
      this._customerAuthService,
      CustomerService customer_service,
      OutputService output_service)
      : super(customer_service, output_service);

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("model") && customer?.id != null)
    {
      bookingService.cancelStreaming();
      bookingService.streamAll(new FirebaseQueryParams(searchProperty: "customer_id", searchValue: customer.id));
    }
  }

  @override
  Future save() async
  {
    try
    {
      Customer old = await customerService.fetch(customer.id, force: true, cache: false);

      /**
       * This will throw on unique constraint failure
       */
      await customerService.set(customer.id, customer);

      if (customer.email != old.email)
      {
        _customerAuthService.unregister(old.email);
        _customerAuthService.register(customer.email);
      }
      _onSaveController.add(customer.id);
    }
    catch (e)
    {
      await cancel();
      _outputService.set(e.toString());
      _onSaveController.add(null);
    }
  }

  CustomerService get customerService => _service;
  Customer get customer => model;

  String selectedBookingId;
  final BookingService bookingService;
  final CustomerAuthService _customerAuthService;
}
