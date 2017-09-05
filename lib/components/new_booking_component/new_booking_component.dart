// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_calendar/bokain_calendar.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/model_components/customer/customer_add_component.dart';

@Component(
    selector: 'bo-new-booking',
    styleUrls: const ['new_booking_component.css'],
    templateUrl: 'new_booking_component.html',
    directives: const [BookingDetailsComponent, CORE_DIRECTIVES, CustomerAddComponent, DataTableComponent, materialDirectives],
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

    /**
     * Something went wrong creating a new customer, close modal
     */
    if (bookingBuffer.customerId == null) onSaveController.add(null);
  }

  Future saveBooking() async
  {
    String id = await bookingService.push(bookingBuffer);
    Booking b = await bookingService.fetch(id, force: true);

    // Generate booking confirmation email
    Map<String, String> params = new Map();
    params["service_name"] = service.name;
    params["customer_name"] = "${customer.firstname} ${customer.lastname}";
    params["user_name"] = "${user.firstname} ${user.lastname}";
    params["salon_name"] = salon.name;
    params["salon_address"] = "${salon.street}, ${salon.postalCode}, ${salon.city}";
    params["salon_phone"] = salon.phone;
    params["date"] = _mailerService.formatDatePronounced(bookingBuffer.startTime);
    params["start_time"] = _mailerService.formatHM(bookingBuffer.startTime);
    params["end_time"] = _mailerService.formatHM(bookingBuffer.endTime);
    params["cancel_code"] = b.cancelCode;

    /**
     * TODO: move minimum cancel booking hours variable into a config service
     */
    params["latest_cancel_booking_time"] = ModelBase.timestampFormat(b.startTime.add(const Duration(hours: -24)));

    _mailerService.mail(phrase.get('email_new_booking', params: params), phrase.get('booking_confirmation'), customer.email);
    onSaveController.add(b);
  }

  SelectionOptions<ServiceAddon> get serviceAddons => _serviceAddons;

  Customer get customer => customerService.get(bookingBuffer.customerId);
  Salon get salon => salonService.get(bookingBuffer.salonId);
  Room get room => salonService.getRoom(bookingBuffer.roomId);
  Service get service => serviceService.get(bookingBuffer.serviceId);
  User get user => userService.get(bookingBuffer.userId);

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