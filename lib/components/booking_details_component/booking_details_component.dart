// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';

@Component(
    selector: 'bo-booking-details',
    styleUrls: const ['booking_details_component.css'],
    templateUrl: 'booking_details_component.html',
    directives: const [materialDirectives, FoModalComponent],
    providers: const [BillogramService],
    pipes: const [PhrasePipe]
)
class BookingDetailsComponent implements OnDestroy, OnChanges
{
  BookingDetailsComponent(
      this._router,
      this.phrase,
      this._billogramService,
      this._bookingService,
      this.customerService,
      this.salonService,
      this.serviceService,
      this.serviceAddonService,
      this.userService,
      this._mailerService);

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    _addons.clear();
    _totalPrice = 0;

    if (service != null && booking != null)
    {
      _totalPrice = service.price;
      if (booking.serviceAddonIds != null) _addons = serviceAddonService.getModelsAsList(booking.serviceAddonIds);
      for (ServiceAddon addon in _addons)
      {
        _totalPrice += addon.price;
      }
    }
  }

  void ngOnDestroy()
  {
    _onBookingChangeController.close();
  }

  Future cancel() async
  {
    // Generate booking confirmation email
    Map<String, String> stringParams = new Map();

    stringParams["service_name"] = "${service?.name}";
    stringParams["customer_name"] = "${customer?.firstname} ${customer?.lastname}";
    stringParams["user_name"] = "${user?.firstname} ${user?.lastname}";
    stringParams["salon_name"] = "${salon.name}";
    stringParams["salon_address"] = "${salon?.street}, ${salon?.postalCode}, ${salon?.city}";
    stringParams["date"] = _mailerService.formatDatePronounced(booking.startTime);
    stringParams["start_time"] = _mailerService.formatHM(booking.startTime);
    stringParams["end_time"] = _mailerService.formatHM(booking.endTime);
    _mailerService.mail(phrase.get(['_email_cancel_booking'], params: stringParams), phrase.get(['booking_cancellation']), customer.email);

    await _bookingService.patchRemove(booking, update_remote: true);
    await _bookingService.remove(booking.id);
    booking = null;
    _onBookingChangeController.add(null);
  }

  Future toggleNoshow() async
  {
    booking.noshow = !booking.noshow;
    await _bookingService.set(booking.id, booking);
  }

  Future generateInvoice() async
  {
    await _billogramService.generateNoShow(booking, customer, [service], addons);
    booking.invoiceSent = true;
    await _bookingService.set(booking.id, booking);
  }

  void rebook()
  {
    _bookingService.rebookBuffer = booking;
    booking = null;
    _onBookingChangeController.add(booking);
    _router.navigate(['Calendar']);
  }

  num get totalPrice => _totalPrice;

  Customer get customer => customerService.getModel(booking?.customerId);
  Room get room => salonService.getRoom(booking?.roomId);
  Salon get salon => salonService.getModel(booking?.salonId);
  Service get service => serviceService.getModel(booking?.serviceId);
  User get user => userService.getModel(booking?.userId);
  List<ServiceAddon> get addons => _addons;

  List<ServiceAddon> _addons = new List();
  num _totalPrice = 0;
  bool confirmModalOpen = false;
  final StreamController<Booking> _onBookingChangeController = new StreamController();
  final BillogramService _billogramService;
  final BookingService _bookingService;
  final CustomerService customerService;
  final PhraseService phrase;
  final SalonService salonService;
  final ServiceService serviceService;
  final ServiceAddonService serviceAddonService;
  final UserService userService;
  final MailerService _mailerService;
  final Router _router;

  @Input('booking')
  Booking booking;

  @Input('showActionButtons')
  bool showActionButtons = true;

  @Output('bookingChange')
  Stream<Booking> get onBookingChangeOutput => _onBookingChangeController.stream;
}
