// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

//import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show Salon, User, BookingService, CalendarService, PhraseService;
import 'package:bokain_admin/components/calendar_component/week_schedule_component.dart';
import 'package:bokain_admin/components/calendar_component/month_calendar_component.dart';
import 'package:bokain_admin/components/calendar_component/week_stepper_component.dart';

@Component(
    selector: 'bo-booking-add',
    styleUrls: const ['booking_add_component.css'],
    templateUrl: 'booking_add_component.html',
    directives: const [materialDirectives, MonthCalendarComponent, WeekScheduleComponent, WeekStepperComponent],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.OnPush
)
class BookingAddComponent
{
  BookingAddComponent(this.bookingService, this.calendarService, this.phrase);

  void openWeekTab(DateTime dt)
  {
    activeTabIndex = 0;
    date = dt;
  }

  @Input('user')
  User user;

  @Input('salon')
  Salon salon;

  @Input('scheduleMode')
  bool scheduleMode = false;

  DateTime date = new DateTime.now();


  int activeTabIndex = 0;
  final BookingService bookingService;
  final CalendarService calendarService;
  final PhraseService phrase;
}