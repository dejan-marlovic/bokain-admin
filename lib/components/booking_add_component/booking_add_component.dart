// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_admin/components/select_time_component/select_time_component.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService, CustomerService, UserService, SalonService, ServiceAddonService, ServiceService;
import 'package:bokain_models/bokain_models.dart' show Booking, Customer, Room, Salon, Service, ServiceAddon, User;

@Component(
    selector: 'bo-booking-add',
    styleUrls: const ['booking_add_component.css'],
    templateUrl: 'booking_add_component.html',
    directives: const [materialDirectives, DataTableComponent, SelectTimeComponent],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.Default
)
class BookingAddComponent
{
  BookingAddComponent(this.phrase, this._bookingService, this.customerService, this.salonService, this.serviceAddonService, this.serviceService, this.userService)
  {
  }

  void pickCustomer(String id)
  {
    booking.customerId = id;
    booking.secondaryProgress = 50;
  }

  Future saveBooking() async
  {
    String bookingId = await _bookingService.push(booking);
    userService.patchBookings(booking.userId, selectedUser.bookingIds..add(bookingId));
    customerService.patchBookings(booking.customerId, selectedCustomer.bookingIds..add(bookingId));
    salonService.patchBookings(booking.salonId, selectedSalon.bookingIds..add(bookingId));
  }

  void stepBack()
  {
    if (booking.progress > 0) booking.progress -= 50;
  }

  void stepForward()
  {
    booking.progress = booking.secondaryProgress;
    if (booking.progress == 50) booking.secondaryProgress = 100;
    else if (booking.progress == 100) saveBooking();
  }

  bool get nextStepDisabled
  {
    return
      (booking.progress == 0 && booking.customerId == null) || (booking.progress == 25 && booking.serviceId == null) ||
      (booking.progress == 50 && booking.startTime == null);
  }

  String get formattedDurationAndPrice
  {
    if (selectedService == null || booking.duration == null || booking.price == null) return "";
    return "${booking.duration.inMinutes} min, ${booking.price.toInt()} ${phrase.get(['currency'], capitalize_first: false)}";
  }

  SelectionOptions<ServiceAddon> get serviceAddons => _serviceAddons;

  Customer get selectedCustomer => customerService.getModel(booking.customerId);
  Salon get selectedSalon => salonService.getModel(booking.salonId);
  Room get selectedRoom => salonService.getRoom(booking.roomId);
  Service get selectedService => serviceService.getModel(booking.serviceId);
  User get selectedUser => userService.getModel(booking.userId);

  @Input('booking')
  Booking booking;

  final PhraseService phrase;
  final BookingService _bookingService;
  final CustomerService customerService;
  final UserService userService;
  final SalonService salonService;
  final ServiceAddonService serviceAddonService;
  final ServiceService serviceService;
  bool sendBookingConfirmation = true;
  SelectionModel<ServiceAddon> addonSelection;
  SelectionOptions<ServiceAddon> _serviceAddons;
}