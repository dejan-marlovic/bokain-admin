// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart' show GlyphComponent;
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/calendar_component/increment_component/increment_component.dart';

@Component(
    selector: 'bo-increment-group',
    styleUrls: const ['increment_group_component.css'],
    templateUrl: 'increment_group_component.html',
    directives: const [GlyphComponent, IncrementComponent],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class IncrementGroupComponent implements OnChanges
{
  IncrementGroupComponent(this.bookingService, this.serviceService, this.customerService);

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    Increment i = increments.first;
    UserState us = i.userStates.containsKey(userId) ? i.userStates[userId] : null;

    booking = (us == null) ? null : bookingService.getModel(us.bookingId);
    calendarState = us?.state;

    customer = (booking == null) ? null : customerService.getModel(booking.customerId);
    service = (booking == null) ? null : serviceService.getModel(booking.serviceId);
  }

  final BookingService bookingService;
  final ServiceService serviceService;
  final CustomerService customerService;

  Booking booking;
  Customer customer;
  Service service;
  String calendarState;

  @Input('increments')
  List<Increment> increments = new List();

  @Input('userId')
  String userId;
}