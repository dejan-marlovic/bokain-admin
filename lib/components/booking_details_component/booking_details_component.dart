// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService, CustomerService, SalonService, ServiceService, UserService;
import 'package:bokain_models/bokain_models.dart' show Booking, Customer, Room, Salon, Service, User;

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
  BookingDetailsComponent(this.phrase, this.bookingService, this.customerService, this.salonService, this.serviceService, this.userService);

  Customer get customer => customerService.getModel(booking.customerId);
  User get user => userService.getModel(booking.userId);

  void confirmAndRemove()
  {
    String bookingId = booking.id;
    bookingService.remove(bookingId);
    user.bookingIds.remove(bookingId);
    userService.patchBookings(booking.userId, user.bookingIds).then((_) => onAfterRemove.emit(bookingId));

    Customer customer = customerService.getModel(booking.customerId);
    customer.bookingIds.remove(booking.id);
    customerService.patchBookings(booking.customerId, customer.bookingIds);

    Salon salon = salonService.getModel(booking.salonId);
    salon.bookingIds.remove(booking.id);
    salonService.patchBookings(booking.salonId, salon.bookingIds);

    booking = null;
  }

  Room get room => salonService.getRoom(booking.roomId);
  Salon get salon => salonService.getModel(booking.salonId);
  Service get service => serviceService.getModel(booking.serviceId);

  @Input('booking')
  Booking booking;

  @Output('afterRemove')
  EventEmitter<String> onAfterRemove = new EventEmitter();

  final PhraseService phrase;
  final SalonService salonService;
  final ServiceService serviceService;
  final BookingService bookingService;
  final CustomerService customerService;
  final UserService userService;
}
