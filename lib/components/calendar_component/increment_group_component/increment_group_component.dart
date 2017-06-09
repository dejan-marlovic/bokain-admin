// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart' show GlyphComponent;
import 'package:intl/intl.dart' show DateFormat;
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/calendar_component/increment_component/increment_component.dart';

@Component(
    selector: 'bo-increment-group',
    styleUrls: const ['../calendar_component.css', 'increment_group_component.css'],
    templateUrl: 'increment_group_component.html',
    directives: const [GlyphComponent, IncrementComponent],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class IncrementGroupComponent implements OnChanges, OnDestroy
{
  IncrementGroupComponent(this.bookingService, this.serviceService, this.customerService, this._phraseService)
  {
    new Timer.periodic(const Duration(minutes:1), (t) => now = new DateTime.now());
  }

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    Increment i = increments.first;
    UserState us = i.userStates.containsKey(userId) ? i.userStates[userId] : null;

    booking = (us == null) ? null : bookingService.getModel(us.bookingId);
    calendarState = us?.state;

    customer = (booking == null) ? null : customerService.getModel(booking.customerId);
    service = (booking == null) ? null : serviceService.getModel(booking.serviceId);
  }

  void ngOnDestroy()
  {
    onBookingClickController.close();
  }

  String get bookingId => (userId == null || increments.isEmpty || !increments.first.userStates.containsKey(userId)) ? null : increments.first.userStates[userId].bookingId;

  String outputRow(int i)
  {
    switch (i)
    {
      case 0:
        return hm.format(increments.first.startTime) + " - " + hm.format(increments.last.endTime);
        break;

      case 1:
        return serviceName;
        break;

      case 2:
        return customerName;
        break;

      default:
        return "";
        break;
    }
  }

  String getColor(Increment i) => (i.startTime.isBefore(now)) ? "rgba(0,0,0,0.2)" : "transparent";

  String get backgroundColor
  {
    if (service != null) return service.color;

    switch (calendarState)
    {
      case "break":
        return "rgba(1,167,157,1)";
        break;

      case "open":
        return "rgba(1,167,157,0.6)";
        break;

      case "sick":
        return "palevioletred";
        break;

      default:
        return "#eee";
        break;
    }
  }

  String get color => (calendarState == null) ? "#888" : "white";

  String get serviceName
  {
    if (service == null) return _phraseService.get([calendarState]);

    // Bad, replace with pipe or directive
    else return (service.name.length <= 20) ? service.name : service.name.substring(0, 17) + "...";
  }

  String get customerName
  {
    if (customer == null) return "";
    String name = "${customer.firstname} ${customer.lastname}";

    /// Bad, replace with pipe or directive
    return (name.length <= 20) ? name : name.substring(0, 17) + "...";
  }

  bool get star => (booking != null);
  bool get plus => (booking != null);

  final BookingService bookingService;
  final ServiceService serviceService;
  final CustomerService customerService;
  final PhraseService _phraseService;
  final StreamController<String> onBookingClickController = new StreamController();

  Booking booking;
  Customer customer;
  Service service;
  String calendarState;

  @Input('increments')
  List<Increment> increments = new List();

  @Input('userId')
  String userId;

  @Output('click')
  Stream<String> get onBookingClickOutput => onBookingClickController.stream;

  DateFormat hm = new DateFormat.Hm();
  DateTime now = new DateTime.now();

}