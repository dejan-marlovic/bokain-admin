// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/editable_model/editable_model_service.dart' show CustomerService, UserService, SalonService, ServiceService;
import 'package:bokain_models/bokain_models.dart' show Booking, Customer, Salon, Service, User;

@Component(
    selector: 'bo-booking-add',
    styleUrls: const ['booking_add_component.css'],
    templateUrl: 'booking_add_component.html',
    directives: const [materialDirectives, DataTableComponent, ROUTER_DIRECTIVES],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.Default
)
class BookingAddComponent
{
  BookingAddComponent(this.phrase, this.customerService, this.salonService, this.serviceService, this.userService)
  {
  }

  void pickCustomer(String id)
  {
    booking.customerId = id;
    activeProgress = 25;
    secondaryProgress = 50;
  }

  void pickSalon(String id)
  {
    activeProgress = 50;
    secondaryProgress = 75;
    booking.salonId = id;
  }

  void pickService(String id)
  {
    booking.serviceId = id;
    activeProgress = 75;
    secondaryProgress = 100;
  }

  void pickUser(String id)
  {
    booking.userId = id;
  }

  void stepForward()
  {
    if (activeProgress < 100) activeProgress += 25;
    if (secondaryProgress < 100) secondaryProgress += 25;
  }

  void stepBack()
  {
    if (activeProgress > 0)
    {
      activeProgress -= 25;
      secondaryProgress -= 25;
    }
  }

  Customer get selectedCustomer => customerService.getModel(booking.customerId);
  Salon get selectedSalon => salonService.getModel(booking.salonId);
  Service get selectedService => serviceService.getModel(booking.serviceId);
  User get selectedUser => userService.getModel(booking.userId);

  @Input('user')
  void set user(String value)
  {
    booking.userId = value;
  }


  Booking booking = new Booking.empty();

  final PhraseService phrase;
  final CustomerService customerService;
  final UserService userService;
  final SalonService salonService;
  final ServiceService serviceService;

  int activeProgress = 0;
  int secondaryProgress = 25;
}
