// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Day, Salon, User;
import 'package:bokain_admin/components/booking_add_component/booking_add_component.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService;
import 'package:bokain_admin/services/calendar_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';


@Component(
    selector: 'bo-month-calendar',
    styleUrls: const ['calendar_component.css','month_calendar_component.css'],
    templateUrl: 'month_calendar_component.html',
    directives: const [materialDirectives, BookingAddComponent, BookingDetailsComponent],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.Default
)
class MonthCalendarComponent
{
  MonthCalendarComponent(this.phrase, this.bookingService, this.calendarService)
  {
    date = new DateTime.now();
  }

  void advanceMonth(int count)
  {
    DateTime oldDate = monthDays.first;
    DateTime newDate = oldDate;
    while (newDate.month == oldDate.month)
    {
      newDate = newDate.add(new Duration(days:27*count));
    }
    date = newDate;
    changeMonthOutput.emit(monthDays.first);
  }

  bool isPopulated(DateTime date)
  {
    Day day = calendarService.getDay(salon?.id, date);
    return (day != null && day.isPopulated);
  }


  @Input('date')
  void set date(DateTime dt)
  {
    monthDays.clear();

    /// First day of month
    DateTime startDate = new DateTime(dt.year, dt.month, 1, 12);
    DateTime iDate = new DateTime(startDate.year, startDate.month, 1, 12);

    while (iDate.month == startDate.month)
    {
      monthDays.add(iDate);
      iDate = iDate.add(const Duration(days: 1));
    }
  }

  String get currentMonth => phrase.get(["month_${monthDays?.first?.month}"]);

  final BookingService bookingService;
  final CalendarService calendarService;
  final PhraseService phrase;
  List<DateTime> monthDays = new List();

  @Input('salon')
  Salon salon;

  @Input('user')
  User user;

  @Output('select')
  EventEmitter<DateTime> select = new EventEmitter();

  @Output('changeMonth')
  EventEmitter<DateTime> changeMonthOutput = new EventEmitter();
}