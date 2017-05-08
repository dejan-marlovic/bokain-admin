// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show Booking, Customer, Room, Salon, Service, User, BookingService, CustomerService, PhraseService, SalonService, ServiceService, UserService;
import 'package:bokain_admin/services/mailer_service.dart';

@Component(
    selector: 'bo-booking-details',
    styleUrls: const ['booking_details_component.css'],
    templateUrl: 'booking_details_component.html',
    directives: const [materialDirectives, ROUTER_DIRECTIVES],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.Default
)
class BookingDetailsComponent
{
  BookingDetailsComponent(this._router, this.phrase, this._bookingService, this.customerService, this.salonService, this.serviceService, this.userService, this._mailerService);

  Customer get customer => customerService.getModel(booking?.customerId);
  User get user => userService.getModel(booking?.userId);

  Future confirmAndRemove() async
  {
    await _bookingService.remove(booking.id);

    booking = null;
    onBookingController.add(booking);
  }

  void rebook()
  {
    _bookingService.rebookBuffer = booking;
    booking = null;
    onBookingController.add(booking);
    _router.navigate(['Calendar']);
  }

  Room get room => salonService.getRoom(booking?.roomId);
  Salon get salon => salonService.getModel(booking?.salonId);
  Service get service => serviceService.getModel(booking?.serviceId);

  @Input('booking')
  Booking booking;

  @Input('showActionButtons')
  bool showActionButtons = true;


  @Output('bookingChange')
  Stream<Booking> get bookingChange => onBookingController.stream;

  final StreamController<Booking> onBookingController = new StreamController();

  final PhraseService phrase;
  final SalonService salonService;
  final ServiceService serviceService;
  final BookingService _bookingService;
  final CustomerService customerService;
  final UserService userService;
  final MailerService _mailerService;
  final Router _router;
}
