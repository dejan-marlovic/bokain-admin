// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController, StreamSubscription;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show BookingService, CalendarService, Day, Salon, User;
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';
import 'package:bokain_admin/pipes/week_pipe.dart';

@Component(
    selector: 'bo-month-calendar',
    styleUrls: const ['../calendar_component.css','month_calendar_component.css'],
    templateUrl: 'month_calendar_component.html',
    directives: const [materialDirectives, BookingDetailsComponent],
    providers: const [CalendarService],
    pipes: const [PhrasePipe, WeekPipe]
)
class MonthCalendarComponent implements OnChanges, OnDestroy
{
  MonthCalendarComponent(this.bookingService, this.calendarService)
  {
    onDayAddedListener = calendarService.onDayAdded.listen((day)
    {
      for (int i = 0; i < 35; i++)
      {
        if (monthDays[i].startTime.isAtSameMomentAs(day.startTime))
        {
          monthDays[i] = day;
          break;
        }

      }
      //monthDays[index] = day;
    });

    setDate(new DateTime.now());
  }

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    setDate(date);
  }

  void ngOnDestroy()
  {
    onChangeMonthController.close();
    onDateClickController.close();
    onDayAddedListener?.cancel();
  }

  bool populated(Day d) => d.increments.where((i) => i.userStates.containsKey(user.id)).isNotEmpty && d.salonId == salon.id;

  void setDate(DateTime dt)
  {
    date = new DateTime(dt.year, dt.month, 1, Day.startHour, Day.startMinute);
    firstDate = new DateTime(dt.year, dt.month, 1, Day.startHour, Day.startMinute);

    while (firstDate.weekday > 1) firstDate = firstDate.add(const Duration(days: -1));

    calendarService.setFilters(firstDate, firstDate.add(const Duration(days: 35)));
    for (int i = 0; i < 35; i++)
    {
      monthDays[i] = new Day(null, salon?.id, firstDate.add(new Duration(days: i)));
    }
  }

  void advance(int month_count)
  {
    int prevYear = date.year;
    int prevMonth = date.month;
    while (date.month == prevMonth && date.year == prevYear) date = date.add(new Duration(days: (month_count < 0) ? -1 : 1));

    /// Can only advance one month at a time
    setDate(date);
    onChangeMonthController.add(date);
  }

  final BookingService bookingService;
  final CalendarService calendarService;
  DateTime firstDate;
  List<Day> monthDays = new List(35);
  final StreamController<DateTime> onDateClickController = new StreamController();
  final StreamController<DateTime> onChangeMonthController = new StreamController();
  StreamSubscription<Day> onDayAddedListener;

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