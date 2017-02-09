// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Increment;
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/services/booking_service.dart';
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
    directives: const [materialDirectives, BookingDetailsComponent],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.OnPush /// Ignore events fired from outside of this component
)
class WeekCalendarComponent
{
  WeekCalendarComponent(this.phrase, this.bookingService, this.calendarService)
  {
    // Monday
    DateTime iDate = new DateTime.now();
    iDate = new DateTime(iDate.year, iDate.month, iDate.day - (iDate.weekday - 1));

    for (int i = 0; i < 7; i++)
    {
      weekdays[i] = iDate;
      iDate = iDate.add(const Duration(days: 1));
    }
  }

  void advanceWeek(int week_count)
  {
    for (int i = 0; i < 7; i++)
    {
      weekdays[i] = weekdays[i].add(new Duration(days: 7 * week_count));
    }
  }

  void parseIncrementMouseDown(Increment increment)
  {
    if (increment.bookingId == null && selectedState.isNotEmpty)
    {
      dragging = true;
      _dm = (increment.state == selectedState) ? DragMode.remove : DragMode.add;
      increment.state = (_dm == DragMode.add) ? selectedState : null;
    }
    else bookingDetails.booking = bookingService.bookingMap[increment.bookingId];
  }

  void parseIncrementMouseEnter(Increment increment)
  {
    if (increment.bookingId == null && selectedState.isNotEmpty)
    {
      highlightedBookingId = null;
      if (!dragging) return;
      increment.state = (_dm == DragMode.add) ? selectedState : null;
    }
    else highlightedBookingId = increment.bookingId;
  }

  void parseIncrementMouseUp(Increment increment)
  {
    calendarService.save(calendarService.getDay(selectedUserId, increment.startTime));
  }

  final BookingService bookingService;
  final CalendarService calendarService;
  final PhraseService phrase;

  bool dragging = false;
  DragMode _dm = DragMode.remove;
  String selectedUserId = "TEMPUSERID";
  String selectedState = "";
  String highlightedBookingId;
  List<DateTime> weekdays = new List(7);

  @ViewChild('bookingDetails')
  BookingDetailsComponent bookingDetails;
}
