// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'dart:html' as dom;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/calendar_component/day_base/day_base.dart';
import 'package:bokain_admin/components/calendar_component/increment_component/increment_component.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';

@Component(
    selector: 'bo-booking-view-day',
    styleUrls: const ['../calendar_component.css', 'booking_view_day_component.css'],
    templateUrl: 'booking_view_day_component.html',
    directives: const [materialDirectives, IncrementComponent],
    pipes: const [PhrasePipe],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class BookingViewDayComponent extends DayBase implements OnDestroy
{
  BookingViewDayComponent(BookingService book, PhraseService phr, CalendarService cal,
      SalonService sal, UserService usr) : super(book, cal, phr, sal, usr);

  void ngOnDestroy()
  {
    _onBookingSelectController.close();
    onDateClickController.close();
  }

  void onIncrementMouseDown(Increment increment)
  {
    if (!disabled && (selectedUser != null || selectedSalon != null))
    {
      if (scheduleMode && !increment.userStates.containsKey(selectedUser.id))
      {
        increment.userStates[selectedUser.id] = new UserState(selectedUser.id);
      }
      else if (increment.userStates.containsKey(selectedUser.id))
      {
        UserState us = increment.userStates[selectedUser.id];
        if (scheduleMode && us.bookingId == null) firstHighlighted = lastHighlighted = increment;
        else if (!scheduleMode && us.bookingId != null)
        {
          _onBookingSelectController.add(bookingService.getModel(increment.userStates[selectedUser.id].bookingId));
        }
      }
    }
  }

  void onIncrementMouseEnter(dom.MouseEvent e, Increment increment)
  {
    if (scheduleMode && !disabled && selectedUser != null && selectedSalon != null && e.buttons == 1)
    {
      /// User is dragging the mouse and the increment is not booked for the
      /// selected user, highlight the increment
      if (!increment.userStates.containsKey(selectedUser.id))
      {
        increment.userStates[selectedUser.id] = new UserState(selectedUser.id);
      }
      if (increment.userStates[selectedUser.id].bookingId == null) lastHighlighted = increment;
      else firstHighlighted = lastHighlighted = null;
    }
  }

  void applyHighlightedChanges()
  {
    if (scheduleMode && !disabled && firstHighlighted != null && lastHighlighted != null && selectedUser != null && selectedSalon != null)
    {
      //Day day = week.firstWhere((d) => d.isSameDateAs(firstHighlighted.startTime));

      bool add = firstHighlighted.userStates[selectedUser.id].state == null;
      day.increments.where(isHighlighted).forEach((inc)
      {
        if (!inc.userStates.containsKey(selectedUser.id)) inc.userStates[selectedUser.id] = new UserState(selectedUser.id);
        inc.userStates[selectedUser.id].state = (add) ? selectedState : null;
      });

      calendarService.save(day).then((_) => firstHighlighted = lastHighlighted = null);
    }
  }

  bool isHighlighted(Increment i)
  {
    if (firstHighlighted == null || lastHighlighted == null) return false;

    if (firstHighlighted.startTime.isBefore(lastHighlighted.startTime))
    {
      return (i.startTime.isAfter(firstHighlighted.startTime) || i.startTime.isAtSameMomentAs(firstHighlighted.startTime)) &&
          (i.endTime.isBefore(lastHighlighted.endTime) || i.endTime.isAtSameMomentAs(lastHighlighted.endTime));
    }
    else
    {
      return (i.startTime.isAfter(lastHighlighted.startTime) || i.startTime.isAtSameMomentAs(lastHighlighted.startTime)) &&
          (i.endTime.isBefore(firstHighlighted.endTime) || i.endTime.isAtSameMomentAs(firstHighlighted.endTime));
    }
  }

  DateTime get date => super.day.startTime;

  Increment firstHighlighted, lastHighlighted;
  final StreamController<DateTime> onDateClickController = new StreamController();
  final StreamController<Booking> _onBookingSelectController = new StreamController();

  @Input('selectedState')
  String selectedState = "open";

  @Input('scheduleMode')
  bool scheduleMode = false;

  @Input('user')
  void set user(User value) { super.selectedUser = value; }

  @Input('salon')
  void set salon(Salon value) { super.selectedSalon = value; }

  @Input('date')
  @override
  void set date(DateTime value) { super.date = value; }

  @Input('disabled')
  bool disabled = false;

  @Output('bookingSelect')
  Stream<Booking> get onBookingSelectOutput => _onBookingSelectController.stream;

  @Output('dateClick')
  Stream<DateTime> get onDateClickOutput => onDateClickController.stream;
}


