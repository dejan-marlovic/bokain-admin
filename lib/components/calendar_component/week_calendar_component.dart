// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

//import 'dart:async';
import 'dart:html' as dom;
import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Booking, Day, Increment, Salon, User;
import 'package:bokain_admin/components/calendar_component/increment_component.dart';
import 'package:bokain_admin/services/calendar_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-week-calendar',
    styleUrls: const ['calendar_component.css','week_calendar_component.css'],
    templateUrl: 'week_calendar_component.html',
    directives: const [materialDirectives, IncrementComponent],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.Default
)
class WeekCalendarComponent
{
  WeekCalendarComponent(this.phrase, this._calendarService)
  {
    date = new DateTime.now();
  }

  void advanceWeek(int week_count)
  {
    for (int i = 0; i < 7; i++)
    {
      weekdays[i] = weekdays[i].add(new Duration(days: 7 * week_count));
    }
    currentWeek = _getWeekOf(weekdays.first);
    changeWeekOutput.emit(weekdays.first);
  }

  void setState(List<Increment> increments)
  {
    Set<Day> days = new Set();
    for (Increment increment in increments)
    {
      Day d = _calendarService.getDay(user?.id, salon?.id, increment.startTime);
      increment.state = (increments.first.state == selectedState) ? null : selectedState;
      days.add(d);
    }
    for (Day day in days) _calendarService.save(day);

    firstDraggedIncrement = null;
  }

  void clearHighlight()
  {
    firstDraggedIncrement = lastDraggedIncrement = null;
  }

  void onIncrementMouseDown(Increment increment)
  {
    if (increment.bookingId == null)
    {
      firstDraggedIncrement = lastDraggedIncrement = increment;
      //increment.state = selectedState;
    }
    else
    {
      // TODO else open booking details
    }
  }

  void onIncrementMouseEnter(dom.MouseEvent e, Increment increment)
  {
    // LMB is pressed and the increment is not booked
    if (e.buttons == 1 && increment.bookingId == null)
    {
      lastDraggedIncrement = increment;
    }
  }

  void applyHighlightedChanges()
  {
    Day day = _calendarService.getDay(user.id, salon.id, firstDraggedIncrement.startTime);
    day.increments.where(isHighlighted).forEach((increment) => increment.state = (firstDraggedIncrement.state == null) ? selectedState : null);
    _calendarService.save(day);
    clearHighlight();
  }

  bool isHighlighted(Increment increment)
  {
    if (firstDraggedIncrement == null || lastDraggedIncrement == null) return false;

    DateTime startTime = increment.startTime.add(const Duration(seconds: 1));
    DateTime endTime = increment.endTime.add(const Duration(seconds: -1));

    if (firstDraggedIncrement.startTime.isBefore(lastDraggedIncrement.startTime))
    {
      return startTime.isAfter(firstDraggedIncrement.startTime) &&
             endTime.isBefore(lastDraggedIncrement.endTime);
    }
    else
    {
      return startTime.isAfter(lastDraggedIncrement.startTime) &&
             endTime.isBefore(firstDraggedIncrement.endTime);
    }
  }

  List<Increment> getIncrements(DateTime day) => _calendarService.getDay(user?.id, salon?.id, day)?.increments;

  int _getWeekOf(DateTime date)
  {
    /// Convert any date to the monday of that dates' week
    DateTime mondayDate = date.add(new Duration(days:-(date.weekday-1)));
    DateTime firstMondayOfYear = new DateTime(date.year);
    while (firstMondayOfYear.weekday != 1)
    {
      firstMondayOfYear = firstMondayOfYear.add(const Duration(days:1));
    }
    Duration difference = mondayDate.difference(firstMondayOfYear);
    return (difference.inDays ~/ 7).toInt() + 1;
  }

  String get currentMonth => phrase.get(["month_${weekdays.first.month}"]);

  @Input('date')
  void set date(DateTime date)
  {
    DateTime iDate = new DateTime(date.year, date.month, date.day, 12);
    // Monday
    iDate = new DateTime(iDate.year, iDate.month, iDate.day - (iDate.weekday - 1), 12);
    currentWeek = _getWeekOf(iDate);
    for (int i = 0; i < 7; i++)
    {
      weekdays[i] = iDate;
      iDate = iDate.add(const Duration(days: 1));
    }
  }

  @Input('user')
  User user;

  @Input('salon')
  Salon salon;

  @Output('changeWeek')
  EventEmitter<DateTime> changeWeekOutput = new EventEmitter();

  final CalendarService _calendarService;
  final PhraseService phrase;

  String selectedState = "open";
  int currentWeek;
  List<DateTime> weekdays = new List(7);

  Increment firstDraggedIncrement, lastDraggedIncrement;

  Booking selectedBooking;
}