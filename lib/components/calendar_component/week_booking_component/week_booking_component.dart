// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show BookingService, CalendarService, PhraseService, SalonService, UserService, Booking, Salon, Service, ServiceAddon, User;
import 'package:bokain_admin/components/calendar_component/booking_time_component/booking_time_component.dart';
import 'package:bokain_admin/components/calendar_component/day_booking_component/day_booking_component.dart';
import 'package:bokain_admin/components/calendar_component/week_base/week_base.dart';
import 'package:bokain_admin/components/new_booking_component/new_booking_component.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';

@Component(
    selector: 'bo-week-booking',
    styleUrls: const ['../calendar_component.css', '../week_base/week_base.css', 'week_booking_component.css'],
    templateUrl: 'week_booking_component.html',
    directives: const [materialDirectives, DayBookingComponent, NewBookingComponent, BookingDetailsComponent, BookingTimeComponent],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.OnPush
)
class WeekBookingComponent extends WeekBase implements OnDestroy
{
  WeekBookingComponent(BookingService booking_service, PhraseService phrase_service, CalendarService calendar_service,
                       SalonService salon_service, UserService user_service) :
        super(booking_service, calendar_service, salon_service, user_service, phrase_service);

  void ngOnDestroy()
  {
    onDayClickController.close();
  }

  @Input('user')
  void set user(User value)
  {
    selectedUser = value;
  }

  @Input('salon')
  void set salon(Salon value)
  {
    selectedSalon = value;
  }

  @Input('date')
  @override
  void set date(DateTime value) { super.date = value; }

  @Input('disabled')
  bool disabled = false;

  @Output('dayClick')
  Stream<DateTime> get onDayClickOutput => onDayClickController.stream;

  Service selectedService;
  List<ServiceAddon> selectedServiceAddons;
  Booking bufferBooking;
  String selectedRoomId;
  final StreamController<DateTime> onDayClickController = new StreamController();

  Duration serviceDurationTotal = const Duration(seconds: 0);
}


