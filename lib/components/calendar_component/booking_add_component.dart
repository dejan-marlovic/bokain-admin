// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

//import 'dart:async' show Stream, StreamController;
import 'dart:async' show StreamController, Stream;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show Salon, User, BookingService, CalendarService, PhraseService;
import 'package:bokain_admin/components/calendar_component/week_schedule_component.dart';
import 'package:bokain_admin/components/calendar_component/month_calendar_component.dart';
import 'package:bokain_admin/components/calendar_component/week_booking_component.dart';
import 'package:bokain_admin/components/calendar_component/week_stepper_component.dart';

@Component(
    selector: 'bo-booking-add',
    styleUrls: const ['booking_add_component.css'],
    templateUrl: 'booking_add_component.html',
    directives: const [materialDirectives, MonthCalendarComponent, WeekBookingComponent, WeekScheduleComponent, WeekStepperComponent],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.OnPush
)
class BookingAddComponent implements OnDestroy
{
  BookingAddComponent(this.bookingService, this.calendarService, this.phrase);

  void ngOnDestroy()
  {
    onActiveTabIndexController.close();
  }

  void openWeekTab(DateTime dt)
  {
    //activeTabIndex = 0;
    date = dt;
    onActiveTabIndexController.add(0);
  }

  @Input('user')
  User user;

  @Input('salon')
  Salon salon;

  @Input('scheduleMode')
  bool scheduleMode = false;

  @Input('activeTabIndex')
  int activeTabIndex = 0;

  @Output('activeTabIndexChange')
  Stream<int> get onActiveTabIndexOutput => onActiveTabIndexController.stream;

  DateTime date = new DateTime.now();

  final BookingService bookingService;
  final CalendarService calendarService;
  final PhraseService phrase;
  final StreamController<int> onActiveTabIndexController = new StreamController();
}