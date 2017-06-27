// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show BookingService, CalendarService, Day, Salon, User;
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';


@Component(
    selector: 'bo-month-calendar',
    styleUrls: const ['../calendar_component.css','month_calendar_component.css'],
    templateUrl: 'month_calendar_component.html',
    directives: const [materialDirectives, BookingDetailsComponent],
    providers: const [CalendarService],
    pipes: const [],
    changeDetection: ChangeDetectionStrategy.Default
)
class MonthCalendarComponent implements OnChanges, OnDestroy
{
  MonthCalendarComponent(this.bookingService, this.calendarService)
  {
    date = new DateTime.now();
    calendarService.onDayAdded.listen((day)
    {
      if (day.containsUser(user.id) && day.salonId == salon.id)
      {
        monthDays.removeWhere((d) => d.startTime.day == day.startTime.day);
        monthDays.add(day);
        monthDays.sort((d1, d2) => d1.startTime.difference(d2.startTime).inDays);
      }
    });
  }

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    date = new DateTime(date.year, date.month, 1, 12);
    DateTime iDate = new DateTime(date.year, date.month, 1, 12);
    while (iDate.month == date.month) { iDate = iDate.add(const Duration(days: 1)); }
    iDate = iDate.add(const Duration(days: -1));

    monthDays = new List.generate(iDate.day, (index) => new Day(null, salon.id, date.add(new Duration(days: index))));
    calendarService.setFilters(date, iDate);
  }

  void ngOnDestroy()
  {
    onChangeMonthController.close();
    onDateClickController.close();
  }

  void advance(int month_count)
  {
    DateTime oldDate = date;
    DateTime newDate = date;
    while (newDate.month == oldDate.month) { newDate = newDate.add(new Duration(days:27*month_count)); }
    date = newDate;
    onChangeMonthController.add(date);
  }

  final BookingService bookingService;
  final CalendarService calendarService;
  List<Day> monthDays = new List();
  final StreamController<DateTime> onDateClickController = new StreamController();
  final StreamController<DateTime> onChangeMonthController = new StreamController();

  @Input('date')
  DateTime date;

  @Input('salon')
  Salon salon;

  @Input('user')
  User user;

  @Output('dateClick')
  Stream<DateTime> get onDateClickOutput => onDateClickController.stream;

  @Output('changeMonth')
  Stream<DateTime> get changeMonthOutput => onChangeMonthController.stream;
}