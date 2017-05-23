// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show CalendarService, PhraseService, SalonService, UserService, Booking, Salon, Service, ServiceAddon, User;
import 'package:bokain_admin/components/calendar_component/day_booking_component/day_booking_component.dart';
import 'package:bokain_admin/components/calendar_component/week_base/week_base.dart';

@Component(
    selector: 'bo-week-booking',
    styleUrls: const ['../calendar_component.css', '../week_base/week_base.css', 'week_booking_component.css'],
    templateUrl: 'week_booking_component.html',
    directives: const [materialDirectives, DayBookingComponent],
    pipes: const [DatePipe],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class WeekBookingComponent extends WeekBase implements OnDestroy
{
  WeekBookingComponent(PhraseService phrase_service, CalendarService calendar_service,
                       SalonService salon_service, UserService user_service) :
        super(calendar_service, salon_service, user_service, phrase_service);

  void ngOnDestroy()
  {
    onDateClickController.close();
    onTimeSelectController.close();
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

  @Output('dateClick')
  Stream<DateTime> get onDateClickOutput => onDateClickController.stream;

  @Output('timeSelect')
  Stream<Booking> get onTimeSelectOutput => onTimeSelectController.stream;

  Service selectedService;
  List<ServiceAddon> selectedServiceAddons;
  Booking bufferBooking;
  String selectedRoomId;
  final StreamController<DateTime> onDateClickController = new StreamController();
  final StreamController<Booking> onTimeSelectController = new StreamController();

  Duration serviceDurationTotal = const Duration(seconds: 0);
}


