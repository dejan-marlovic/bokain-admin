// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream;
import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Booking, Day, Increment, Room, Salon, Service, ServiceAddon, User, UserState;
import 'package:bokain_admin/components/calendar_component/booking_time_component.dart';
import 'package:bokain_admin/components/calendar_component/service_picker_component.dart';
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
    directives: const [materialDirectives, BookingAddComponent, BookingDetailsComponent, BookingTimeComponent, ServicePickerComponent],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.OnPush
)
class WeekBookingComponent extends WeekCalendarBase
{
  WeekBookingComponent(BookingService booking_service, PhraseService phrase_service, CalendarService calendar_service,
                       SalonService salon_service, UserService user_service, this._serviceService) :
        super(booking_service, calendar_service, salon_service, user_service, phrase_service);

  SelectionOptions<Service> get availableServiceOptions
  {
    int sortAlpha(Service a, Service b) => a.name.compareTo(b.name);
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

  Room getQualifiedRoom(Increment increment, Day day)
  {
    /// Current increment is not available due to out of rooms
    List<Room> qualifiedRooms = _qualifiedRooms.where((room) => bookingService.find(increment.startTime, room.id) == null).toList();

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

  User getQualifiedUser(Increment increment, Day day)
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
        qualifiedUserIds.removeWhere((id)
        => !otherIncrement.userStates.containsKey(id)
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

  void updateServiceState()
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

      _qualifiedRooms = salonService.getRooms(selectedSalon.roomIds).where((room) => room.serviceIds.contains(selectedService.id)).toList(growable: false);
    }
  }

  Future onTimeSelect(Booking booking) async
  {
    if (bookingService.rebookBuffer == null)
    {
      bufferBooking = booking;
      bufferBooking.salonId = selectedSalon.id;
      bufferBooking.serviceId = selectedService.id;
    }
    else
    {
      bookingService.rebookBuffer.roomId = booking.roomId;
      bookingService.rebookBuffer.userId = booking.userId;
      bookingService.rebookBuffer.startTime = booking.startTime;
      bookingService.rebookBuffer.endTime = booking.endTime;
      bookingService.rebookBuffer.duration = serviceDurationTotal;
      bookingService.rebookBuffer.salonId = selectedSalon.id;
      bookingService.rebookBuffer.serviceId = selectedService.id;
      bookingService.rebookBuffer.serviceAddonIds = new List.from(selectedService.serviceAddonIds);

      await bookingService.remove(bookingService.rebookBuffer.id);
      await bookingService.set(bookingService.rebookBuffer.id, bookingService.rebookBuffer);


      bookingService.rebookBuffer = null;
    }
  }

  Service get selectedService => _serviceService.selectedModel;

  @Output('changeWeek')
  Stream<DateTime> get changeWeek => onChangeWeek.stream;

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
    updateServiceState();
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
    updateServiceState();
  }

  @Input('date')
  @override
  void set date(DateTime value) { super.date = value; }

  void set selectedService(Service service) { _serviceService.selectedModel = service; }

  List<ServiceAddon> selectedServiceAddons;
  Booking bufferBooking;
  String selectedRoomId;
  final ServiceService _serviceService;
  Duration serviceDurationTotal = const Duration(seconds: 0);
  List<Room> _qualifiedRooms = [];
}


