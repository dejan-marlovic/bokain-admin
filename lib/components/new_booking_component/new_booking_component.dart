// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_calendar/bokain_calendar.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/model_components/customer/customer_add_component.dart';

@Component(
    selector: 'bo-new-booking',
    styleUrls: const ['new_booking_component.css'],
    templateUrl: 'new_booking_component.html',
    directives: const [materialDirectives, BookingDetailsComponent, CustomerAddComponent, DataTableComponent],
    pipes: const [PhrasePipe]
)
class NewBookingComponent
{
  NewBookingComponent(
      this.phrase,
      this.bookingService,
      this.customerService,
      this.salonService,
      this.serviceAddonService,
      this.serviceService,
      this.userService,
      this._mailerService);

  void pickCustomer(String id)
  {
    bookingBuffer.customerId = id;
  }

  Future saveBooking() async
  {
    String id = await bookingService.push(bookingBuffer);
    Booking b = bookingService.getModel(id);

    // Generate booking confirmation email
    Map<String, String> stringParams = new Map();
    stringParams["service_name"] = "${selectedService.name}";
    stringParams["customer_name"] = "${selectedCustomer.firstname} ${selectedCustomer.lastname}";
    stringParams["user_name"] = "${selectedUser.firstname} ${selectedUser.lastname}";
    stringParams["salon_name"] = "${selectedSalon.name}";
    stringParams["salon_address"] = "${selectedSalon.street}, ${selectedSalon.postalCode}, ${selectedSalon.city}";
    stringParams["date"] = _mailerService.formatDatePronounced(bookingBuffer.startTime);
    stringParams["start_time"] = _mailerService.formatHM(bookingBuffer.startTime);
    stringParams["end_time"] = _mailerService.formatHM(bookingBuffer.endTime);

    _mailerService.mail(phrase.get('_email_new_booking', params: stringParams), phrase.get('booking_confirmation'), selectedCustomer.email);
    onSaveController.add(b);
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
  Stream<Booking> get onSaveOutput => onSaveController.stream;

  final PhraseService phrase;
  final BookingService bookingService;
  final CustomerService customerService;
  final UserService userService;
  final SalonService salonService;
  final ServiceAddonService serviceAddonService;
  final ServiceService serviceService;
  final MailerService _mailerService;
  SelectionModel<ServiceAddon> addonSelection;
  SelectionOptions<ServiceAddon> _serviceAddons;

  final StreamController<Booking> onSaveController = new StreamController();
}