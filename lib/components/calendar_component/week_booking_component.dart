// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream;
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
      : super(calendar, salon, user, phrase);

  SelectionOptions<Service> get availableServiceOptions
  {
    int sortAlpha(Service a, Service b)
    {
      return a.name.compareTo(b.name);

      //return -1;
    }

    if (selectedSalon == null) return null;

    else if (selectedUser == null)
    {
      // Filter so that only services supported by the salon are listed
      List<String> ids = salonService.getServiceIds(selectedSalon);
      List<Service> services = _serviceService.getModelObjects(ids: ids);
      services.sort(sortAlpha);
      return new SelectionOptions([new OptionGroup(services)]);
    }
    else
    {
      // Filter so that only services supported by the user/salon are listed
      List<String> ids = salonService.getServiceIds(selectedSalon).where(selectedUser.serviceIds.contains).toList();
      List<Service> services = _serviceService.getModelObjects(ids: ids);
      services.sort(sortAlpha);
      return new SelectionOptions([new OptionGroup(services)]);
    }
  }

  List<Increment> salonBookableIncrements(Day day)
  {
    if (selectedService == null) return day.increments;

    List<Increment> output = new List.from(day.increments);

    /// First remove all increments that aren't open or are booked
    bool openIncrementGate(Increment increment)
    {
      if (increment.userStates.isEmpty) return true;
      return (increment.userStates.values.firstWhere((us) => us.bookingId == null && us.state == "open", orElse: () => null) == null);
    }
    output.removeWhere(openIncrementGate);

    /// Then remove all increments that doesn't have enough time for the selected service (unless dynamic service time)
    if (selectedService.dynamicTime == false)
    {
      Duration serviceDurationTotal = new Duration(minutes: selectedService.duration.inMinutes);
      if (selectedServiceAddons != null)
      {
        for (ServiceAddon addon in selectedServiceAddons)
        {
          serviceDurationTotal += addon.duration;
        }
      }
      bool notEnoughTimeGate(Increment increment)
      {
        DateTime expEndTime = increment.startTime.add(serviceDurationTotal);
        return (output.firstWhere((i) => i.endTime.isAfter(expEndTime) || i.endTime.isAtSameMomentAs(expEndTime), orElse: () => null) == null);
      }
      output.removeWhere(notEnoughTimeGate);
    }

    return output;
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
  void lockOnService(Increment first_increment)
  {
    lastHighlighted = null;

    if (selectedSalon == null || selectedService == null || first_increment == null) return;

    /// Find out what increments are covered by the service duration
    DateTime expStartTime = first_increment.startTime;
    DateTime expEndTime = expStartTime.add(selectedService.duration);
    if (selectedServiceAddons != null) for (ServiceAddon addon in selectedServiceAddons) expEndTime = expEndTime.add(addon.duration);

    // Round to nearest increment
    while (expEndTime.minute % Increment.duration.inMinutes != 0)
    {
      expEndTime = expEndTime.add(const Duration(minutes: 1));
    }

    Duration expDuration = expStartTime.difference(expEndTime);
    Day day = calendarService.getDay(selectedSalon.id, first_increment.startTime);
    clearHighlight();

    bool findMatchingHighlight(UserState us, Increment increment)
    {
      /// Gate the increment is open (the iterated user is registered to work)
      /// and isn't occupied by another booking
      if (us.state == "open" && us.bookingId == null)
      {
        /// Highlight available increments covered by the duration of the service

        Iterable<Increment> covered = day.increments.where((inc)
        {
          return
            (inc.startTime.isAfter(expStartTime) || inc.startTime.isAtSameMomentAs(expStartTime))
                && (inc.endTime.isBefore(expEndTime) || inc.endTime.isAtSameMomentAs(expEndTime))
                && inc.userStates.containsKey(us.userId)
                && inc.userStates[us.userId].state == "open"
                && inc.userStates[us.userId].bookingId == null;
        });

        if (covered.isNotEmpty)
        {
          /// Gate increments are contiguous
          for (int i = 1; i < covered.length; i++)
          {
            if (!covered.elementAt(i).startTime.isAtSameMomentAs(covered.elementAt(i-1).endTime))
            {
              if (selectedService.dynamicTime)
              {
                firstHighlighted = covered.first;
                lastHighlighted = covered.elementAt(i-1);
                return true;
              }
              else return false;
            };
          }

          /// Gate check enough room for the service (or dynamic service duration)
          Duration covDuration = covered.first.startTime.difference(covered.last.endTime);
          if (covDuration == expDuration || selectedService.dynamicTime)
          {
            firstHighlighted = covered.first;
            lastHighlighted = covered.last;
            return true;
          }
        }
      }
      return false;
    }

    List<UserState> firstIncrementUserStates = _getActiveUserStates(first_increment);
    for (UserState us in firstIncrementUserStates)
    {
      if (findMatchingHighlight(us, first_increment)) return;
    }

    // If no highlight was found, try again with the previous increment
    Increment previous = day.increments.firstWhere((inc) => inc.endTime.isAtSameMomentAs(first_increment.startTime), orElse: () => null);
    if (previous != null) lockOnService(previous);

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

  /// Return active user states for an increment based on context of selected user(s)
  List<UserState> _getActiveUserStates(Increment increment)
  {
    // TODO sort userStates on user bookingRank

    if (increment.userStates.isEmpty) return [];

    /// No specific user selected, return all [UserStates] of the increment
    if (selectedUser == null) return new List.from(increment.userStates.values);
    else
    {
      /// A user has been selected, return it's [UserState] or empty list if non-existing
      return (increment.userStates.containsKey(selectedUser.id)) ? [increment.userStates[selectedUser.id]] : [];
    }
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
  void set user(User value)
  {
    selectedUser = value;
    if (selectedService != null && selectedUser != null && !selectedUser.serviceIds.contains(selectedService.id)) selectedService = null;
    clearHighlight();
  }

  @Input('salon')
  void set salon(Salon value)
  {
    selectedSalon = value;
    if (selectedService != null && (selectedSalon == null || !salonService.getServiceIds(selectedSalon).contains(selectedService.id))) selectedService = null;
    clearHighlight();
  }

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

