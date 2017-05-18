// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show BookingService, CalendarService, PhraseService, SalonService, ServiceService, UserService, Day, Increment, Room, Salon, Service, ServiceAddon, User, UserState;
import 'package:bokain_admin/components/calendar_component/booking_time_component/booking_time_component.dart';
import 'package:bokain_admin/components/calendar_component/day_base/day_base.dart';
import 'package:bokain_admin/components/new_booking_component/new_booking_component.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';

@Component(
    selector: 'bo-day-booking',
    styleUrls: const ['../calendar_component.css', 'day_booking_component.css'],
    templateUrl: 'week_booking_component.html',
    directives: const [materialDirectives, NewBookingComponent, BookingDetailsComponent, BookingTimeComponent],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class DayBookingComponent extends DayBase implements OnDestroy
{
  DayBookingComponent(BookingService booking_service, PhraseService phrase_service, CalendarService calendar_service,
                       SalonService salon_service, UserService user_service, this._serviceService) :
        super(booking_service, phrase_service, salon_service, user_service);

  void ngOnDestroy()
  {
    onTimeSelectController.close();
  }

  SelectionOptions<Service> get availableServiceOptions
  {
    int sortAlpha(Service a, Service b) => a.name.compareTo(b.name);
    if (selectedSalon == null) return null;

    else if (selectedUser == null)
    {
      // Filter so that only services supported by the salon are listed
      List<Service> services = _serviceService.getModelsAsList(salonService.getServiceIds(selectedSalon));
      services.sort(sortAlpha);
      return new SelectionOptions([new OptionGroup(services)]);
    }
    else
    {
      // Filter so that only services supported by the user/salon are listed
      List<String> ids = salonService.getServiceIds(selectedSalon).where(selectedUser.serviceIds.contains).toList();
      List<Service> services = _serviceService.getModelsAsList(ids);
      services.sort(sortAlpha);
      return new SelectionOptions([new OptionGroup(services)]);
    }
  }

  Iterable<Increment> getQualifiedIncrements(Duration duration)
  {
    bool qualified(Increment inc)
    {
      /// Get last open booking
      Increment last = day.increments.lastWhere((inc)
      => inc.userStates.isNotEmpty && inc.userStates.values.where((us) => us.state == "open" && us.bookingId == null).isNotEmpty, orElse: () => null);

      return (last == null) ? false : inc.startTime.add(duration).isBefore(last.endTime.add(const Duration(minutes: 1)));
    }
    return day.increments.where(qualified);
  }

  Room getQualifiedRoom(Increment increment)
  {
    List<Room> qualifiedRooms = _qualifiedRooms.where((room) => room.status == "active" && bookingService.find(increment.startTime, room.id) == null).toList();

    DateTime expEndTime = increment.startTime.add(serviceDurationTotal);
    DateTime iTime = increment.startTime.add(Increment.duration);

    while (iTime.isBefore(expEndTime))
    {
      // Find next increment
      Increment nextIncrement = day.increments.firstWhere((inc) => inc.startTime.isAtSameMomentAs(iTime), orElse: () => null);
      if (nextIncrement == null) return null;

      qualifiedRooms.removeWhere((room) => bookingService.find(nextIncrement.startTime, room.id) != null);
      if (qualifiedRooms.isEmpty) return null;

      iTime = iTime.add(Increment.duration);
    }

    return (qualifiedRooms.isEmpty) ? null : qualifiedRooms.first;
  }

  User getQualifiedUser(Increment increment)
  {
    if (selectedService == null) return null;

    DateTime expEndTime = increment.startTime.add(serviceDurationTotal);
    DateTime iTime = increment.startTime.add(Increment.duration);

    /// No user selected, find first available user
    if (selectedUser == null)
    {
      UserState state = increment.userStates.values.firstWhere((us) => us.bookingId == null && us.state == "open", orElse: () => null);
      if (state == null) return null;

      List<String> qualifiedUserIds = increment.userStates.keys.where(selectedService.userIds.contains).toList();

      while (iTime.isBefore(expEndTime))
      {
        // Find next increment
        Increment otherIncrement = day.increments.firstWhere((inc) => inc.startTime.isAtSameMomentAs(iTime), orElse: () => null);

        // Next increment was not found
        if (otherIncrement == null) return null;

        // Remove any user ids not present in this increment or when the other increment is booked or other increment is not open
        // or user is disabled/frozen
        qualifiedUserIds.removeWhere((id)
        =>
        (userService.getModel(id) as User).status != "active"
            || !otherIncrement.userStates.containsKey(id)
            || otherIncrement.userStates[id].state != "open"
            || otherIncrement.userStates[id].bookingId != null);

        // No qualified users left
        if (qualifiedUserIds.isEmpty) return null;

        iTime = iTime.add(Increment.duration);
      }
      /// TODO sort by booking rank
      return (qualifiedUserIds.isEmpty) ? null : userService.getModel(qualifiedUserIds.first);
    }
    else //if (selectedUser != null)
    {
      if (!increment.userStates.containsKey(selectedUser.id)) return null;

      UserState us = increment.userStates[selectedUser.id];
      if (us.bookingId != null || us.state != "open") return null;

      while (iTime.isBefore(expEndTime))
      {
        // Find next increment
        Increment nextIncrement = day.increments.firstWhere((inc) => inc.startTime.isAtSameMomentAs(iTime), orElse: () => null);

        // Next increment was not found or user was not found in the increment
        if (nextIncrement == null
            || !nextIncrement.userStates.containsKey(selectedUser.id)
            || nextIncrement.userStates[selectedUser.id].bookingId != null
            || nextIncrement.userStates[selectedUser.id].state != "open") return null;

        iTime = iTime.add(Increment.duration);
      }
      return selectedUser;
    }
  }

  @Input('user')
  void set user(User value)
  {
    selectedUser = value;

    if (selectedUser != null)
    {
      if (selectedService == null || !selectedUser.serviceIds.contains(selectedService.id))
      {
        // If the user can't perform the currently selected service, set it to be the first service the user can perform instead
        selectedService = _serviceService.getModel(selectedUser.serviceIds?.first);
        selectedServiceAddons = null;
      }
    }
    _updateServiceState();
  }

  @Input('salon')
  void set salon(Salon value)
  {
    selectedSalon = value;

    if (selectedSalon != null)
    {
      // Clear service selection unless the salon can perform the service
      List<String> salonServiceIds = salonService.getServiceIds(selectedSalon);
      if (selectedService == null || !salonService.getServiceIds(selectedSalon).contains(selectedService.id))
      {
        selectedService = (salonServiceIds.isEmpty) ? null : _serviceService.getModel(salonServiceIds.first);
        selectedServiceAddons = null;
      }
    }
    _updateServiceState();
  }

  void _updateServiceState()
  {
    if (selectedSalon == null || selectedService == null)
    {
      serviceDurationTotal = const Duration(seconds: 0);
      _qualifiedRooms = [];
    }
    else
    {
      serviceDurationTotal = new Duration(minutes: selectedService.duration.inMinutes);
      if (selectedServiceAddons != null)
      {
        for (ServiceAddon addon in selectedServiceAddons)
        {
          serviceDurationTotal += addon.duration;
        }
      }
      while (serviceDurationTotal.inMinutes % Increment.duration.inMinutes != 0)
      {
        serviceDurationTotal += Increment.duration;
      }
      _qualifiedRooms = salonService.getRooms(selectedSalon.roomIds).where((room) => room.serviceIds.contains(selectedService.id)).toList(growable:false);
    }
  }

  @Input('date')
  @override
  void set date(DateTime value) { super.date = value; }

  @Output('timeSelect')
  Stream<String> get onTimeSelectOutput => onTimeSelectController.stream;

  Service selectedService;
  List<ServiceAddon> selectedServiceAddons;
  String selectedRoomId;
  final ServiceService _serviceService;
  final StreamController<String> onTimeSelectController = new StreamController();
  Duration serviceDurationTotal = const Duration(seconds: 0);
  List<Room> _qualifiedRooms = [];
}


