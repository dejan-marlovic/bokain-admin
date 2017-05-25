// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';

@Component(
    selector: 'bo-booking-details',
    styleUrls: const ['booking_details_component.css'],
    templateUrl: 'booking_details_component.html',
    directives: const [materialDirectives],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.Default
)
class BookingDetailsComponent implements OnDestroy
{
  BookingDetailsComponent(this._router, this.phrase, this._bookingService, this.customerService, this.salonService, this.serviceService, this.userService, this._mailerService);

  void ngOnDestroy()
  {
    _onBookingChangeController.close();
  }

  Customer get customer => customerService.getModel(booking?.customerId);
  User get user => userService.getModel(booking?.userId);

  Future confirmAndRemove() async
  {
    // Generate booking confirmation email
    Map<String, String> stringParams = new Map();

    Service selectedService = serviceService.getModel(booking.serviceId);
    Customer selectedCustomer = customerService.getModel(booking.customerId);
    User selectedUser = userService.getModel(booking.userId);
    Salon selectedSalon = salonService.getModel(booking.salonId);
    stringParams["service_name"] = "${selectedService?.name}";
    stringParams["customer_name"] = "${selectedCustomer?.firstname} ${selectedCustomer?.lastname}";
    stringParams["user_name"] = "${selectedUser?.firstname} ${selectedUser?.lastname}";
    stringParams["salon_name"] = "${selectedSalon.name}";
    stringParams["salon_address"] = "${selectedSalon?.street}, ${selectedSalon?.postalCode}, ${selectedSalon?.city}";
    stringParams["date"] = _mailerService.formatDatePronounced(booking.startTime);
    stringParams["start_time"] = _mailerService.formatHM(booking.startTime);
    stringParams["end_time"] = _mailerService.formatHM(booking.endTime);
    _mailerService.mail(phrase.get(['_email_cancel_booking'], params: stringParams), phrase.get(['booking_cancellation']), selectedCustomer.email);

    await _bookingService.patchRemove(booking, update_remote: true);
    await _bookingService.remove(booking.id);
    booking = null;
    _onBookingChangeController.add(null);
  }

  void rebook()
  {
    _bookingService.rebookBuffer = booking;
    booking = null;
    _onBookingChangeController.add(booking);
    _router.navigate(['Calendar']);
  }

  Room get room => salonService.getRoom(booking?.roomId);
  Salon get salon => salonService.getModel(booking?.salonId);
  Service get service => serviceService.getModel(booking?.serviceId);

  final StreamController<Booking> _onBookingChangeController = new StreamController();
  final PhraseService phrase;
  final SalonService salonService;
  final ServiceService serviceService;
  final BookingService _bookingService;
  final CustomerService customerService;
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
