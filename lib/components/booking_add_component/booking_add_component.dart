// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_models/bokain_models.dart' show Booking, Customer, Room, Salon, Service, ServiceAddon, User, PhraseService, BookingService, CustomerService, UserService, SalonService, ServiceAddonService, ServiceService, MailerService;
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_add_component.dart';



@Component(
    selector: 'bo-booking-add',
    styleUrls: const ['booking_add_component.css'],
    templateUrl: 'booking_add_component.html',
    directives: const [materialDirectives, BookingDetailsComponent, CustomerAddComponent, DataTableComponent],
    providers: const [MailerService],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.Default
)
class BookingAddComponent
{
  BookingAddComponent(this.phrase, this.bookingService, this.customerService, this.salonService, this.serviceAddonService, this.serviceService, this.userService, this._mailerService);

  void pickCustomer(String id)
  {
    bookingBuffer.customerId = id;
    bookingBuffer.secondaryProgress = bookingBuffer.progress = 50;
  }

  Future saveBooking() async
  {
    String bookingId = await bookingService.push(bookingBuffer);

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

    await _mailerService.mail(phrase.get(['_email_new_booking'], params: stringParams), phrase.get(['booking_confirmation']), selectedCustomer.email);
    saveController.add(bookingId);
  }

  void goBack()
  {
    bookingBuffer.progress = 0;
    bookingBuffer.customerId = null;
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
  final BookingService bookingService;
  final CustomerService customerService;
  final UserService userService;
  final SalonService salonService;
  final ServiceAddonService serviceAddonService;
  final ServiceService serviceService;
  final MailerService _mailerService;
  SelectionModel<ServiceAddon> addonSelection;
  SelectionOptions<ServiceAddon> _serviceAddons;

  final StreamController<String> saveController = new StreamController();
}