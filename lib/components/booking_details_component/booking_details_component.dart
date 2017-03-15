// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/editable_model/editable_model_service.dart' show CustomerService, UserService;
import 'package:bokain_models/bokain_models.dart' show Booking, Customer, User;


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
  BookingDetailsComponent(this.phrase, this.customerService, this.userService)
  {
  }

  Customer get customer => customerService.getModel(booking.customerId);
  User get user => userService.getModel(booking.userId);

  Booking booking;

  final PhraseService phrase;
  final CustomerService customerService;
  final UserService userService;
}
