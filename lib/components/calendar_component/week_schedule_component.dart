// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

//import 'dart:async';
import 'dart:async' show Stream;
import 'dart:html' as dom show MouseEvent;
import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Day, Increment, Salon, User;
import 'package:bokain_admin/components/calendar_component/increment_component.dart';
import 'package:bokain_admin/components/calendar_component/week_calendar_base.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService, SalonService;
import 'package:bokain_admin/services/calendar_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-week-schedule',
    styleUrls: const ['calendar_component.css', 'week_calendar_base.css', 'week_schedule_component.css'],
    templateUrl: 'week_schedule_component.html',
    directives: const [materialDirectives, IncrementComponent],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.Default
)
class WeekScheduleComponent extends WeekCalendarBase
{
  WeekScheduleComponent(PhraseService phrase, CalendarService calendar, BookingService booking, SalonService salon)
      : super(calendar, booking, salon, phrase);

  void onIncrementMouseDown(Increment increment)
  {
    if (increment.bookingId == null) firstHighlighted = lastHighlighted = increment;
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
      lastHighlighted = increment;
    }
  }

  void applyHighlightedChanges()
  {
    if (firstHighlighted == null || lastHighlighted == null) return;
    Day day = calendarService.getDay(selectedUser.id, selectedSalon.id, firstHighlighted.startTime);
    bool add = firstHighlighted.state == null;
    day.increments.where(isHighlighted).forEach((increment) => increment.state = (add) ? selectedState : null);
    calendarService.save(day).then((_) => clearHighlight());
  }

  @Output('changeWeek')
  Stream<DateTime> get changeWeek => onChangeWeek.stream;

  @Input('date')
  @override
  void set date(DateTime value)
  {
    super.date = value;
  }

  @Input('user')
  void set user(User value) { selectedUser = value; }

  @Input('salon')
  void set salon(Salon value) { selectedSalon = value; }

  @Output('changeWeek')
  EventEmitter<DateTime> changeWeekOutput = new EventEmitter();

  String selectedState = "open";
}