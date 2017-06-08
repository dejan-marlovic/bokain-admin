// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_admin/components/calendar_component/day_base/day_base.dart';
import 'package:bokain_admin/components/calendar_component/increment_group_component/increment_group_component.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';
import 'package:bokain_models/bokain_models.dart';

@Component(
    selector: 'bo-booking-view-day',
    styleUrls: const ['../calendar_component.css', 'booking_view_day_component.css'],
    templateUrl: 'booking_view_day_component.html',
    directives: const [materialDirectives, IncrementGroupComponent],
    pipes: const [PhrasePipe],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class BookingViewDayComponent extends DayBase implements OnChanges, OnDestroy
{
  BookingViewDayComponent(BookingService book, CalendarService cal, SalonService sal, UserService usr) : super(book, cal, sal, usr);

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (selectedUser != null && day != null && changes.containsKey("user")) _groupIncrements();
  }

  void ngOnDestroy()
  {
    _onBookingSelectController.close();
    onDateClickController.close();
  }

  void onIncrementMouseDown(Increment increment)
  {
    if (!disabled && (selectedUser != null || selectedSalon != null))
    {
      if (increment.userStates.containsKey(selectedUser.id))
      {
        UserState us = increment.userStates[selectedUser.id];
        if (us.bookingId != null)
        {
          _onBookingSelectController.add(bookingService.getModel(increment.userStates[selectedUser.id].bookingId));
        }
      }
    }
  }

  void _groupIncrements()
  {
    incrementGroups.clear();
    incrementGroups.add(new List()..add(day.increments.first));

    for (int i = 1; i < day.increments.length; i++)
    {
      Increment previous = day.increments[i-1];
      Increment current = day.increments[i];

      if (current.userStates.containsKey(selectedUser.id) &&
          previous.userStates.containsKey(selectedUser.id) &&
          current.userStates[selectedUser.id].state != null &&
          current.userStates[selectedUser.id] == previous.userStates[selectedUser.id])
      {
        incrementGroups.last.add(current);
      }

      else incrementGroups.add(new List()..add(current));
    }
  }

  DateTime get date => super.day.startTime;

  final StreamController<DateTime> onDateClickController = new StreamController();
  final StreamController<Booking> _onBookingSelectController = new StreamController();
  final List<List<Increment>> incrementGroups = new List();

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


