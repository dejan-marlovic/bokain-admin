// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Booking, Increment;
import 'package:bokain_admin/components/booking_add_component/booking_add_component.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService;
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
    directives: const [materialDirectives, BookingAddComponent, BookingDetailsComponent],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.OnPush /// Ignore events fired from outside of this component
)
class WeekCalendarComponent
{
  WeekCalendarComponent(this.phrase, this.bookingService, this.calendarService)
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

  void parseIncrementMouseDown(Increment increment)
  {
    if (increment.bookingId == null && selectedState.isNotEmpty)
    {
      dragging = true;
      _dm = (increment.state == selectedState) ? DragMode.remove : DragMode.add;
      increment.state = (_dm == DragMode.add) ? selectedState : null;
    }
    else details.bookingId = increment.bookingId;
  }

  void parseIncrementMouseEnter(Increment increment)
  {
    if (increment.bookingId == null)
    {
      highlightedBookingId = null;
      if (!dragging) return;
      increment.state = (_dm == DragMode.add) ? selectedState : null;
    }
    else highlightedBookingId = increment.bookingId;
  }

  void parseIncrementMouseUp(Increment increment)
  {
    calendarService.save(calendarService.getDay(newBooking.userId, newBooking.salonId, increment.startTime));
  }

  void dismissAddBookingModal()
  {
    showAddBookingModal = false;
    newBooking.progress = 0;
    newBooking.roomId = null;
    newBooking.customerId = null;
    newBooking.startTime = null;
    newBooking.duration = null;
    newBooking.endTime = null;
    newBooking.serviceId = null;
    newBooking.serviceAddonIds?.clear();
  }

  @Input('userId')
  void set userId(String value)
  {
    newBooking.userId = value;
  }

  @Input('salonId')
  void set salonId(String value)
  {
    newBooking.salonId = value;
  }

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

  @Output('changeWeek')
  EventEmitter<DateTime> changeWeekOutput = new EventEmitter();

  String get currentMonth => phrase.get(["month_${weekdays.first.month}"]);

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

  @ViewChild('details')
  BookingDetailsComponent details;

  final BookingService bookingService;
  final CalendarService calendarService;
  final PhraseService phrase;

  bool dragging = false;
  DragMode _dm = DragMode.remove;
  String selectedState = "open";
  String highlightedBookingId;

  List<DateTime> weekdays = new List(7);

  Booking newBooking = new Booking();
  bool showAddBookingModal = false;

  int currentWeek;
}
