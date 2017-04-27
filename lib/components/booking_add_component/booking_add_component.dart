// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/select_time_component/select_time_component.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService, CustomerService, UserService, SalonService, ServiceAddonService, ServiceService;
import 'package:bokain_models/bokain_models.dart' show Booking, Customer, Room, Salon, Service, ServiceAddon, User;

@Component(
    selector: 'bo-booking-add',
    styleUrls: const ['booking_add_component.css'],
    templateUrl: 'booking_add_component.html',
    directives: const [materialDirectives, BookingDetailsComponent, DataTableComponent, SelectTimeComponent],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.Default
)
class BookingAddComponent
{
  BookingAddComponent(this.phrase, this._bookingService, this.customerService, this.salonService, this.serviceAddonService, this.serviceService, this.userService);

  void pickCustomer(String id)
  {
    bookingBuffer.customerId = id;
    bookingBuffer.secondaryProgress = 50;
  }

  Future saveBooking() async
  {
    String bookingId = await _bookingService.push(bookingBuffer);
    await userService.patchBookings(bookingBuffer.userId, selectedUser.bookingIds..add(bookingId));
    await customerService.patchBookings(bookingBuffer.customerId, selectedCustomer.bookingIds..add(bookingId));
    await salonService.patchBookings(bookingBuffer.salonId, selectedSalon.bookingIds..add(bookingId));
    saveController.add(bookingId);
  }

  void stepBack()
  {
    if (bookingBuffer.progress > 0) bookingBuffer.progress -= 50;
  }

  void stepForward()
  {
    bookingBuffer.progress = bookingBuffer.secondaryProgress;
    if (bookingBuffer.progress == 50)
    {
      bookingBuffer.secondaryProgress = 100;
    }
    else if (bookingBuffer.progress == 100) saveBooking();
  }

  bool get nextStepDisabled
  {
    return
      (bookingBuffer.progress == 0 && bookingBuffer.customerId == null) || (bookingBuffer.progress == 25 && bookingBuffer.serviceId == null) ||
      (bookingBuffer.progress == 50 && bookingBuffer.startTime == null);
  }

  String get formattedDurationAndPrice
  {
    if (selectedService == null || bookingBuffer.duration == null || bookingBuffer.price == null) return "";
    return "${bookingBuffer.duration.inMinutes} min, ${bookingBuffer.price.toInt()} ${phrase.get(['currency'], capitalize_first: false)}";
  }

  SelectionOptions<ServiceAddon> get serviceAddons => _serviceAddons;

  Customer get selectedCustomer => customerService.getModel(bookingBuffer.customerId);
  Salon get selectedSalon => salonService.getModel(bookingBuffer.salonId);
  Room get selectedRoom => salonService.getRoom(bookingBuffer.roomId);
  Service get selectedService => serviceService.getModel(bookingBuffer.serviceId);
  User get selectedUser => userService.getModel(bookingBuffer.userId);

  @Input('booking')
  Booking bookingBuffer;

  @Output('save')
  Stream<String> get save => saveController.stream;

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

  final StreamController<String> saveController = new StreamController();
}