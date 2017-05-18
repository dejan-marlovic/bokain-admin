// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'dart:html' as dom show MouseEvent;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show CalendarService, PhraseService, BookingService, SalonService, UserService, Day, Increment, Salon, User, UserState;
import 'package:bokain_admin/components/bo_modal_component/bo_modal_component.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/calendar_component/increment_component/increment_component.dart';
import 'package:bokain_admin/components/calendar_component/week_base/week_base.dart';

@Component(
    selector: 'bo-week-schedule',
    styleUrls: const ['../calendar_component.css', '../week_base/week_base.css', 'week_schedule_component.css'],
    templateUrl: 'week_schedule_component.html',
    directives: const [materialDirectives, BoModalComponent, BookingDetailsComponent, IncrementComponent],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.OnPush
)
class WeekScheduleComponent extends WeekBase implements OnDestroy
{
  WeekScheduleComponent(BookingService booking, CalendarService calendar, SalonService salon, UserService user, PhraseService phrase)
      : super(booking, calendar, salon, user, phrase);

  void ngOnDestroy()
  {
    onDaySelectController.close();
  }

  void onIncrementMouseDown(Increment increment)
  {
    if (!disabled)
    {
      if (selectedUser != null || selectedSalon != null)
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
            selectedBooking = bookingService.getModel(increment.userStates[selectedUser.id].bookingId);
            bookingDetailsModal = true;
          }

        }
      }
    }
  }

  void onIncrementMouseEnter(dom.MouseEvent e, Increment increment)
  {
    if (scheduleMode && !disabled)
    {
      if (selectedUser != null && selectedSalon != null)
      {
        /// User is dragging the mouse and the increment is not booked for the
        /// selected user, highlight the increment
        if (e.buttons == 1)
        {
          if (!increment.userStates.containsKey(selectedUser.id))
          {
            increment.userStates[selectedUser.id] = new UserState(selectedUser.id);
          }
          if (increment.userStates[selectedUser.id].bookingId == null) lastHighlighted = increment;
          else clearHighlight();
        }
      }
    }
  }

  void applyHighlightedChanges()
  {
    if (scheduleMode && !disabled && firstHighlighted != null && lastHighlighted != null && selectedUser != null && selectedSalon != null)
    {
      Day day = week.firstWhere((d) => d.isSameDateAs(firstHighlighted.startTime));

      bool add = firstHighlighted.userStates[selectedUser.id].state == null;
      day.increments.where(isHighlighted).forEach((inc)
      {
        if (!inc.userStates.containsKey(selectedUser.id)) inc.userStates[selectedUser.id] = new UserState(selectedUser.id);
        inc.userStates[selectedUser.id].state = (add) ? selectedState : null;
      });

      calendarService.save(day).then((_) => clearHighlight());
    }
  }

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

  @Input('disabled')
  bool disabled = false;

  @Input('scheduleMode')
  bool scheduleMode = false;

  @Output('dayClick')
  Stream<DateTime> get onSelectOutput => onDaySelectController.stream;

  bool bookingDetailsModal = false;
  String selectedState = "open";


  final StreamController<DateTime> onDaySelectController = new StreamController();
}