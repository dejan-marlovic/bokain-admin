// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show BookingService, CalendarService, PhraseService, SalonService, ServiceService, UserService, Booking, Increment, Room, Salon, Service, ServiceAddon, User, UserState;
import 'package:bokain_admin/components/calendar_component/booking_time_component/booking_time_component.dart';
import 'package:bokain_admin/components/calendar_component/day_base/day_base.dart';

@Component(
    selector: 'bo-day-booking',
    styleUrls: const ['../calendar_component.css', 'day_booking_component.css'],
    templateUrl: 'day_booking_component.html',
    directives: const [materialDirectives, BookingTimeComponent],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class DayBookingComponent extends DayBase implements OnDestroy
{
  DayBookingComponent(BookingService booking_service, PhraseService phrase_service, CalendarService calendar_service,
                       SalonService salon_service, UserService user_service, this._serviceService) :
        super(booking_service, calendar_service, phrase_service, salon_service, user_service);

  void ngOnDestroy()
  {
    onDateClickController.close();
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

  void onIncrementSelect(Increment increment)
  {
    Iterable<String> users = getQualifiedUserIds(increment);
    List<String> rooms = getQualifiedRoomIds(increment);
    if (users.isEmpty || rooms.isEmpty) return;

    Booking booking = new Booking(null);
    booking.startTime = increment.startTime;
    booking.endTime = booking.startTime.add(serviceDurationTotal);
    booking.userId = users.first;
    booking.roomId = rooms.first;

    onTimeSelectController.add(booking);
  }

  String getStatus(Increment increment)
  {
    DateTime startTime = increment.startTime;
    DateTime endTime = increment.startTime.add(serviceDurationTotal);

    Iterable<Increment> coveredIncrements = day.increments.where((i)
    => i.startTime.isAfter(startTime) && i.startTime.isBefore(endTime));

    Iterable<String> userIds = getQualifiedUserIds(increment);
    Iterable<String> roomIds = getQualifiedRoomIds(increment);

    if (userIds.isEmpty || roomIds.isEmpty)
    {
      return "disabled";
    }

    DateTime previousEndTime = increment.endTime;
    for (Increment i in coveredIncrements)
    {
      userIds = getQualifiedUserIds(i).where(userIds.contains);
      roomIds = getQualifiedRoomIds(i).where(roomIds.contains);

      /// No users left, no rooms left or not contiguous time
      if (userIds.isEmpty || roomIds.isEmpty || !i.startTime.isAtSameMomentAs(previousEndTime)) return "disabled";

      previousEndTime = i.endTime;
    }
    return "available";
  }

  List<Increment> get qualifiedIncrements
  {
    if (selectedUser == null)
    {
      Increment lastQualified = day.increments.lastWhere((i) => getQualifiedUserIds(i).isNotEmpty && getQualifiedRoomIds(i).isNotEmpty);

      return day.increments.where((i)
      => i.userStates.isNotEmpty
          && i.startTime.add(serviceDurationTotal).isBefore(lastQualified.endTime.add(const Duration(seconds: 1)))).toList(growable: false);
    }
    else
    {
      Increment lastQualified = day.increments.lastWhere((i) => getQualifiedUserIds(i).contains(selectedUser.id) && getQualifiedRoomIds(i).isNotEmpty);
      return day.increments.where((i)
      => i.userStates.containsKey(selectedUser.id)
          && i.startTime.add(serviceDurationTotal).isBefore(lastQualified.endTime.add(const Duration(seconds: 1)))
      ).toList(growable: false);
    }
  }

  List<String> getQualifiedRoomIds(Increment increment)
  {
    if (selectedService == null) return [];
    List<Room> qualifiedRooms = _qualifiedRooms.where((room) => room.status == "active" && bookingService.find(increment.startTime, room.id) == null).toList();
    return qualifiedRooms.map((r) => r.id).toList();
  }

  List<String> getQualifiedUserIds(Increment increment)
  {
    if (selectedService == null) return [];

    /// No user selected
    if (selectedUser == null)
    {
      return increment.userStates.keys.where((id) => selectedService.userIds.contains(id)
          && increment.userStates[id].bookingId == null
          && increment.userStates[id].state == "open").toList();
    }
    else
    {
      if (!increment.userStates.containsKey(selectedUser.id)) return [];

      UserState us = increment.userStates[selectedUser.id];
      return (us.bookingId == null && us.state == "open") ? [selectedUser.id] : [];
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

  DateTime get date => super.day.startTime;

  @Input('date')
  @override
  void set date(DateTime value) { super.date = value; }

  @Output('dateClick')
  Stream<DateTime> get onDateClickOutput => onDateClickController.stream;

  @Output('timeSelect')
  Stream<Booking> get onTimeSelect => onTimeSelectController.stream;

  Service selectedService;
  List<ServiceAddon> selectedServiceAddons;
  String selectedRoomId;
  final ServiceService _serviceService;
  final StreamController<DateTime> onDateClickController = new StreamController();
  final StreamController<Booking> onTimeSelectController = new StreamController();
  Duration serviceDurationTotal = const Duration(seconds: 0);
  List<Room> _qualifiedRooms = [];
}


