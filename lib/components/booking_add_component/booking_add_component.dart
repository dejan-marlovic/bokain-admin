// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';
import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_admin/components/select_time_component/select_time_component.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show IdModel, BookingService, CustomerService, UserService, SalonService, ServiceAddonService, ServiceService;
import 'package:bokain_models/bokain_models.dart' show Booking, Customer, Increment, Room, Salon, Service, ServiceAddon, User;

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
    booking.secondaryProgress = 25;
    booking.serviceAddonIds.clear();
    booking.startTime = booking.endTime = booking.serviceId = booking.roomId = null;
  }

  void pickService(String id)
  {
    booking.serviceId = id;
    booking.secondaryProgress = 50;
    booking.serviceAddonIds.clear();
    booking.startTime = booking.endTime = booking.roomId = null;
    booking.price = selectedService.price;

    Service s = selectedService;
    booking.duration = new Duration(minutes: s.durationMinutes.toInt());

    if (selectedService.serviceAddonIds.isEmpty)
    {
      _serviceAddons = null;
      addonSelection = null;
    }
    else
    {
      final OptionGroup<ServiceAddon> group = new OptionGroup(serviceAddonService.getModels(selectedService.serviceAddonIds) as List<ServiceAddon>);
      _serviceAddons = new SelectionOptions([group]);

      addonSelection = new SelectionModel.withList(allowMulti: true);
      addonSelection.selectionChanges.listen((_)
      {
        if (selectedService == null) return;
        int totalDuration = selectedService.durationMinutes;
        num totalPrice = selectedService.price;
        for (ServiceAddon addon in addonSelection.selectedValues)
        {
          totalDuration += addon.duration.toInt();
          totalPrice += addon.price;
        }
        booking.duration = new Duration(minutes: totalDuration);
        booking.price = totalPrice;
      });
    }

    booking.duration = new Duration(minutes: s.durationMinutes.toInt());
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
    if (booking.progress > 0) booking.progress -= 25;
  }

  void stepForward()
  {
    if (booking.progress < 100) booking.progress += 25;
    if (booking.progress == 100) saveBooking();
    else if (booking.progress == 75) booking.secondaryProgress = 100;
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

  bool get nextStepDisabled
  {
    return
      (booking.progress == 0 && booking.customerId == null) || (booking.progress == 25 && booking.serviceId == null) ||
      (booking.progress == 50 && booking.startTime == null);
  }

  String get formattedDurationAndPrice
  {
    if (selectedService == null) return "";
    return "${booking.duration.inMinutes} min, ${booking.price.toInt()} ${phrase.get(['currency'], capitalize_first: false)}";
  }

  // Fetch services that the selected user and salon are qualified for
  Map<String, Map<String, String>> get availableServices
  {
    final List<String> salonServiceIds = salonService.getServiceIds(selectedSalon);
    Iterable<String> availableServiceIds = selectedUser.serviceIds.where(salonServiceIds.contains);
    return serviceService.getRows(availableServiceIds.toList(growable: false), true);
  }

  SelectionOptions<ServiceAddon> get serviceAddons => _serviceAddons;

  Customer get selectedCustomer => customerService.getModel(booking.customerId);
  Salon get selectedSalon => salonService.getModel(booking.salonId);
  Room get selectedRoom => salonService.getRoom(booking.roomId);
  Service get selectedService => serviceService.getModel(booking.serviceId);
  User get selectedUser => userService.getModel(booking.userId);

  String get userSelectLabel => userSelection.selectedValues.isEmpty ? phrase.get(['user_plural']) : userSelection.selectedValues.first.model.toString();
  String get salonSelectLabel => salonSelection.selectedValues.isEmpty ? phrase.get(['salon_plural']) : salonSelection.selectedValues.first.model.toString();

  @Input('booking')
  Booking booking;

  @Input('userSelection')
  SelectionModel<IdModel> userSelection;

  @Input('salonSelection')
  SelectionModel<IdModel> salonSelection;

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