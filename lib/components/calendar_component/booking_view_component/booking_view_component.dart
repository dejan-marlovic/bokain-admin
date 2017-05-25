// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show Booking, Salon, User, BookingService, CalendarService, PhraseService;
import 'package:fo_components/fo_components.dart' show FoModalComponent;
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/calendar_component/booking_view_day_component/booking_view_day_component.dart';
import 'package:bokain_admin/components/calendar_component/booking_view_week_component/booking_view_week_component.dart';
import 'package:bokain_admin/components/calendar_component/day_stepper_component/day_stepper_component.dart';
import 'package:bokain_admin/components/calendar_component/month_calendar_component/month_calendar_component.dart';
import 'package:bokain_admin/components/calendar_component/week_stepper_component/week_stepper_component.dart';

@Component(
    selector: 'bo-booking-view',
    styleUrls: const ['booking_view_component.css'],
    templateUrl: 'booking_view_component.html',
    directives: const
    [
      materialDirectives,
      BookingDetailsComponent,
      BookingViewDayComponent,
      BookingViewWeekComponent,
      DayStepperComponent,
      FoModalComponent,
      MonthCalendarComponent,
      WeekStepperComponent
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class BookingViewComponent implements OnDestroy
{
  BookingViewComponent(this.bookingService, this.calendarService, this.phrase);

  void ngOnDestroy()
  {
    _onActiveTabIndexChangeController.close();
  }

  void openWeekTab(DateTime dt)
  {
    activeTabIndex = 1;
    date = dt;
  }

  openDayTab(DateTime dt)
  {
    activeTabIndex = 0;
    date = dt;
  }

  int get activeTabIndex => _activeTabIndex;

  void set activeTabIndex(int value)
  {
    _activeTabIndex = value;
    _onActiveTabIndexChangeController.add(_activeTabIndex);
  }

  @Input('activeTabIndex')
  void set activeTabIndexExternal(int value) { _activeTabIndex = value; }

  @Input('user')
  User user;

  @Input('salon')
  Salon salon;

  @Input('scheduleMode')
  bool scheduleMode = false;

  @Input('calendarAddState')
  String calendarAddState = "open";

  @Output('activeTabIndexChange')
  Stream<int> get onActiveTabIndexChangeOutput => _onActiveTabIndexChangeController.stream;

  DateTime date = new DateTime.now();
  bool showBookingDetailsModal = false;
  Booking selectedBooking;
  int _activeTabIndex = 0;
  final BookingService bookingService;
  final CalendarService calendarService;
  final PhraseService phrase;
  final StreamController<int> _onActiveTabIndexChangeController = new StreamController();
}