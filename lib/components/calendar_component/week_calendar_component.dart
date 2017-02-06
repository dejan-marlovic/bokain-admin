// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Day, Increment;
import 'package:bokain_admin/services/calendar_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';

enum DragMode
{
  add,
  remove
}

@Component(
    selector: 'bo-week-calendar',
    styleUrls: const ['calendar_component.css','week_calendar_component.css'],
    templateUrl: 'week_calendar_component.html',
    directives: const [materialDirectives],
    preserveWhitespace: false
)
class WeekCalendarComponent
{
  WeekCalendarComponent(this.phrase, this.calendarService)
  {
    _setWeek(new DateTime.now());
  }

  void advanceWeek(int week_count)
  {
    _setWeek(_currentMonday.add(new Duration(days: week_count * 7)));
  }

  void parseIncrementMouseDown(Increment increment)
  {
    dragging = true;
    _dm = (increment.open) ? DragMode.remove : DragMode.add;
    increment.open = !increment.open;
  }

  void parseIncrementMouseEnter(Increment increment)
  {
    if (!dragging) return;
    increment.open = _dm == DragMode.add;
  }

  void _setWeek(DateTime date)
  {
    _currentMonday = new DateTime(date.year, date.month, date.day - (date.weekday - 1));
    DateTime iDate = _currentMonday;
    for (int i = 0; i < 7; i++)
    {
      Day day = calendarService.getDay(selectedUserId, iDate);
      if (day == null) day = new Day(iDate);

      day.increments.forEach((i)
      {
          if (temp) i.bookingId = "heja";
          temp = !temp;
      });


      weekdays[i] = day;

      iDate = iDate.add(const Duration(days: 1));
    }
  }

  List<Day> weekdays = new List(7);
  final CalendarService calendarService;
  final PhraseService phrase;
  DateTime _currentMonday;
  String selectedUserId;
  bool dragging = false;
  DragMode _dm = DragMode.remove;

  bool temp = false;


}
