// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_admin/components/select_time_component/select_time_component.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService, CustomerService, UserService, SalonService, ServiceService;
import 'package:bokain_models/bokain_models.dart' show Booking, Customer, Increment, Room, Salon, Service, User;

@Component(
    selector: 'bo-booking-add',
    styleUrls: const ['booking_add_component.css'],
    templateUrl: 'booking_add_component.html',
    directives: const [materialDirectives, DataTableComponent, SelectTimeComponent, ROUTER_DIRECTIVES],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.Default
)
class BookingAddComponent
{
  BookingAddComponent(this.phrase, this._bookingService, this.customerService, this.salonService, this.serviceService, this.userService)
  {
  }

  void pickCustomer(String id)
  {
    booking.customerId = id;
    booking.progress = 25;
  }

  void pickService(String id)
  {
    booking.serviceId = id;
    booking.progress = 50;

    Service s = serviceService.getModel(id);

    // TODO add addon durations
    booking.duration = new Duration(minutes: s.durationMinutes.toInt());
  }

  void pickTime()
  {
    booking.progress = 75;
  }

  Future saveBooking() async
  {
    if (booking.progress < 100)
    {
      String bookingId = await _bookingService.push(booking);
      userService.patchBookings(booking.userId, selectedUser.bookingIds..add(bookingId));
      customerService.patchBookings(booking.customerId, selectedCustomer.bookingIds..add(bookingId));
      salonService.patchBookings(booking.salonId, selectedSalon.bookingIds..add(bookingId));
      booking.progress += 25;
    }
  }

  void stepBack()
  {
    if (booking.progress > 0) booking.progress -= 25;
  }

  void decreaseDuration()
  {
    booking.duration = new Duration(minutes: max(booking.duration.inMinutes - Increment.duration.inMinutes, Increment.duration.inMinutes));
    booking.endTime = booking.startTime.add(booking.duration);
  }

  void increaseDuration()
  {
    booking.duration = new Duration(minutes: booking.duration.inMinutes + Increment.duration.inMinutes);
    booking.endTime = booking.startTime.add(booking.duration);
    serviceService.getRows(selectedUser.serviceIds);
  }

  // Fetch services that the selected user and salon are qualified for
  Map<String, Map<String, String>> get availableServices
  {
    final List<String> salonServiceIds = salonService.getServiceIds(selectedSalon);
    Iterable<String> availableServiceIds = selectedUser.serviceIds.where(salonServiceIds.contains);
    return serviceService.getRows(availableServiceIds.toList(growable: false), true);
  }

  Customer get selectedCustomer => customerService.getModel(booking.customerId);
  Salon get selectedSalon => salonService.getModel(booking.salonId);
  Room get selectedRoom => salonService.getRoom(booking.roomId);
  Service get selectedService => serviceService.getModel(booking.serviceId);
  User get selectedUser => userService.getModel(booking.userId);

  @Input('booking')
  Booking booking = new Booking.empty();

  final PhraseService phrase;
  final BookingService _bookingService;
  final CustomerService customerService;
  final UserService userService;
  final SalonService salonService;
  final ServiceService serviceService;

  bool sendBookingConfirmation = true;
}
