// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream;
import 'dart:html' as dom show MouseEvent;
import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Booking, Day, Increment, Room, Salon, Service, ServiceAddon, User, UserState;
import 'package:bokain_admin/components/calendar_component/service_picker_component.dart';
import 'package:bokain_admin/components/calendar_component/increment_component.dart';
import 'package:bokain_admin/components/calendar_component/week_calendar_base.dart';
import 'package:bokain_admin/components/booking_add_component/booking_add_component.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/services/calendar_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService, SalonService, ServiceService, UserService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-week-booking',
    styleUrls: const ['calendar_component.css', 'week_calendar_base.css', 'week_booking_component.css'],
    templateUrl: 'week_booking_component.html',
    directives: const [materialDirectives, BookingAddComponent, BookingDetailsComponent, IncrementComponent, ServicePickerComponent],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.Default
)
class WeekBookingComponent extends WeekCalendarBase
{
  WeekBookingComponent(PhraseService phrase, CalendarService calendar, SalonService salon, UserService user, this._bookingService, this._serviceService)
      : super(calendar, salon, user, phrase)
  {
  }

  SelectionOptions<Service> get availableServiceOptions
  {
    if (selectedSalon == null) return null;
    else if (selectedUser == null)
    {
      // Filter so that only services supported by the salon are listed
      return new SelectionOptions([new OptionGroup(_serviceService.getModelObjects(ids:salonService.getServiceIds(selectedSalon)))]);
    }
    else
    {
      // Filter so that only services supported by the user/salon are listed
      return new SelectionOptions([new OptionGroup(
          _serviceService.getModelObjects(ids: salonService.getServiceIds(selectedSalon).where(selectedUser.serviceIds.contains).toList(growable: false)))]);
    }
  }
/*
  @override
  List<List<Increment>> get availableWeekIncrements
  {
    if (selectedSalon == null) return [];
    else
    {
      // A salon and service has been specified, disable increments that are unavailable due to out of rooms
      List<Room> qualifiedRooms = salonService.getRooms(selectedSalon.roomIds).toList();
      if (selectedService != null) qualifiedRooms.removeWhere((room) => !room.serviceIds.contains(selectedService.id));

      if (selectedUser == null)
      {
        /// No user is selected, merge all active users' increments
        List<User> users = _userService.getModelObjects();
        if (selectedService != null) users.removeWhere((user) => user.serviceIds.contains(selectedService.id));
        if (users.isEmpty) return [];

        for (int i = 0; i < 7; i++)
        {
          weekDates[i] = bufferDays[i].increments;

          if (selectedService == null)
          {
            for (User user in users)
            {
              List<Increment> userIncrements = calendarService.getIncrements(user, selectedSalon, weekDates[i]);
              for (int j = 0; j < weekDays[i].length; j++)
              {
                if (userIncrements[j].state == "open" && weekDays[i][j].state != "open")
                {
                  userIncrements[j].availableRoomIds = qualifiedRooms.map((r) => r.id).toList();
                  weekDays[i][j] = userIncrements[j];
                }

              }

            }

          }
          //users.sort((usr1, usr2) => (usr1.bookingRank - usr2.bookingRank).toInt());

        }
        return weekDays;
      }
      else
      {
        for (int i = 0; i < 7; i++)
        {
          weekDays[i] = calendarService.getIncrements(selectedUser, selectedSalon, weekDates[i]);

          for (Increment increment in weekDays[i])
          {
            increment.availableRoomIds = qualifiedRooms.map((r) => r.id).toList();
            increment.availableRoomIds.removeWhere((room_id) => _bookingService.find(increment.startTime, room_id) != null);
          }
        }
        return weekDays;
      }
    }
  }
*/
  void highlightIncrements(dom.MouseEvent e, Increment increment)
  {
    lastHighlighted = null;
    UserState state = increment.userStates[selectedUser.id];

    /// The increment is open (the selected user is registered to work)
    if (state == "open")
    {
      /// The increment is not occupied by another booking, and a service has been selected
      if (state.bookingId == null && selectedService != null)
      {
        /// Drag-select booking duration only if the selected service allows it
        if (e.buttons == 1 && selectedService.dynamicTime)
        {
          lastHighlighted = increment;
        }
        else
        {
          /// Highlight available increments covered by the duration of the booking duration
          clearHighlight();
          DateTime startTime = increment.startTime.add(const Duration(seconds: -1));
          DateTime endTime = startTime.add(selectedService.duration).add(const Duration(seconds: -1));
          if (selectedServiceAddons != null) for (ServiceAddon addon in selectedServiceAddons) endTime = endTime.add(addon.duration);

          Day day = calendarService.getDay(selectedSalon.id, increment.startTime);
          Iterable<Increment> coveredIncrements = day.increments.where((i) => i.startTime.isAfter(startTime) && i.endTime.isBefore(endTime));

          selectedRoomId = _evaluateFirstAvailableRoomId(coveredIncrements);
        }
      }
      /// The increment is occupied by another booking, highlight all increments of the booking
      else if (increment.userStates[selectedUser.id].bookingId != null)
      {
        /*
        int index = weekDates.indexOf(weekDates.firstWhere((dt) => dt.weekday == increment.startTime.weekday));
        firstHighlighted = weekDays[index].firstWhere((i) => i.bookingId == state.bookingId, orElse: null);
        lastHighlighted = weekDays[index].lastWhere((i) => i.bookingId == state.bookingId, orElse: null);
        */
      }
    }
  }

  void openBooking(Increment increment)
  {
    UserState state = increment.userStates[selectedUser.id];

    if (state.bookingId == null && firstHighlighted != null && lastHighlighted != null)
    {
      // Open add booking popup
      bufferBooking = new Booking();
      if (lastHighlighted.startTime.isAfter(firstHighlighted.startTime))
      {
        bufferBooking.startTime = firstHighlighted.startTime;
        bufferBooking.endTime = lastHighlighted.endTime;
      }
      else
      {
        bufferBooking.startTime = lastHighlighted.startTime;
        bufferBooking.endTime = firstHighlighted.endTime;
      }
      bufferBooking.duration = bufferBooking.endTime.difference(bufferBooking.startTime);

      bufferBooking.userId = selectedUser.id;
      bufferBooking.salonId = selectedSalon.id;
      bufferBooking.serviceId = selectedService.id;
      bufferBooking.roomId = firstHighlighted.availableRoomIds.first;
    }

    else if (state.bookingId != null)
    {
      selectedBooking = _bookingService.getModel(state.bookingId);

      // Open existing booking details popup
    }
    clearHighlight();
  }

  String _evaluateFirstAvailableRoomId(Iterable<Increment> increments)
  {
    List<String> availableRoomIds = new List.from(increments.first.availableRoomIds);
    bool available(Increment increment)
    {
      /*
      /// Remove any room from availableRoomIds that is not available for this increment
      availableRoomIds.removeWhere((id) => !increment.availableRoomIds.contains(id));
      return (increment.state == "open" && increment.bookingId == null);*/
      return true;
    }
    bool allAvailable()
    {
      if (selectedService == null || selectedSalon == null || selectedSalon.roomIds.isEmpty) return false;
      for (Increment increment in increments)
      {
        if (!available(increment) || availableRoomIds.isEmpty) return false;
      }
      return true;
    }
    if (allAvailable())
    {
      /// All increments are available, highlight
      firstHighlighted = increments.first;
      lastHighlighted = increments.last;
      return availableRoomIds.first;
    }
    else if (available(increments.first) && selectedService.dynamicTime)
    {
      /// First increment is available and the selected service has dynamic time
      firstHighlighted = lastHighlighted = increments.first;
      return (firstHighlighted.availableRoomIds.isEmpty) ? null : firstHighlighted.availableRoomIds.first;
    }
    return null;
  }

  @Output('changeWeek')
  Stream<DateTime> get changeWeek => onChangeWeek.stream;

  @Input('user')
  void set user(User value) { selectedUser = value; }

  @Input('salon')
  void set salon(Salon value) { selectedSalon = value; }

  @Input('date')
  @override
  void set date(DateTime value) { super.date = value; }

  Service selectedService;
  List<ServiceAddon> selectedServiceAddons;
  Booking bufferBooking;
  String selectedRoomId;
  final BookingService _bookingService;
  final ServiceService _serviceService;
}

