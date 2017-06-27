// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/calendar_component/booking_time_component/booking_time_component.dart';
import 'package:bokain_admin/components/calendar_component/day_base/day_base.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';

@Component(
    selector: 'bo-booking-add-day',
    styleUrls: const ['../calendar_component.css', 'booking_add_day_component.css'],
    templateUrl: 'booking_add_day_component.html',
    directives: const [materialDirectives, BookingTimeComponent],
    providers: const [CalendarService],
    pipes: const [PhrasePipe],
    changeDetection: ChangeDetectionStrategy.Default
)
class BookingAddDayComponent extends DayBase implements OnInit, OnChanges, OnDestroy
{
  BookingAddDayComponent(BookingService bs, CalendarService cs, SalonService ss, UserService us) : super(bs, cs, ss, us);

  @override ngOnChanges(Map<String, SimpleChange> changes)
  {
    super.ngOnChanges(changes);

    totalDuration = (selectedService == null) ? const Duration(seconds: 1) : new Duration(minutes: selectedService.durationMinutes);
    if (selectedServiceAddons != null)
    {
      for (ServiceAddon addon in selectedServiceAddons)
      {
        totalDuration += addon.duration;
      }
    }
    salonServiceRooms = _getQualifiedRoomsOfSalonAndService(selectedSalon, selectedService).toList(growable: false);
    qualifiedIncrements = [];
  }

  @override
  void ngOnDestroy()
  {
    super.ngOnDestroy();
    onTimeSelectController.close();
  }

  @override
  void updateDayRemote(Day d)
  {
    super.updateDayRemote(d);
    qualifiedIncrements = _calcQualifiedIncrements().toList(growable: false);
  }

  void makeBooking(Increment increment)
  {
    if (disabled) return;
    Iterable<String> users = _getQualifiedUserIdsForIncrement(increment);
    List<String> rooms = _getQualifiedRoomIdsForIncrement(increment);
    if (users.isEmpty || rooms.isEmpty) return;

    Booking booking = new Booking();
    booking.startTime = increment.startTime;
    booking.endTime = booking.startTime.add(totalDuration);
    booking.dayId = day.id;

    /// TODO random and/or booking rank
    booking.userId = users.first;
    booking.roomId = rooms.first;

    onTimeSelectController.add(booking);
  }

  Iterable<Increment> _calcQualifiedIncrements()
  {
    if (day == null || day.increments.isEmpty || selectedSalon == null) return [];
    try
    {
      return day.increments.where(_available);
    }
    on StateError catch(e)
    {
      print(e);
      return [];
    }
  }

  bool _available(Increment increment)
  {
    DateTime startTime = increment.startTime.add(const Duration(seconds: -1));
    DateTime endTime = increment.startTime.add(totalDuration);

    if (endTime.isAfter(day.endTime)) return false; /// After end of the day

    Iterable<String> userIds = (selectedUser == null) ? _getQualifiedUserIdsForIncrement(increment) : [selectedUser.id];

    Iterable<String> roomIds = _getQualifiedRoomIdsForIncrement(increment);
    if (userIds.isEmpty || roomIds.isEmpty) return false;

    DateTime previousEndTime;

    Iterable<Increment> durationCoveredIncrements = day.increments.where((i) => (i.startTime.isAfter(startTime) && i.startTime.isBefore(endTime)));
    for (Increment i in durationCoveredIncrements)
    {
      if (previousEndTime != null && !i.startTime.isAtSameMomentAs(previousEndTime)) return false;       /// Time is not continuous

      userIds = _getQualifiedUserIdsForIncrement(i).where(userIds.contains);
      roomIds = _getQualifiedRoomIdsForIncrement(i).where(roomIds.contains);
      if (userIds.isEmpty || roomIds.isEmpty) return false;                   /// No users left or no rooms left

      previousEndTime = i.endTime;
    }
    return true;
  }

  Iterable<Room> _getQualifiedRoomsOfSalonAndService(Salon salon, Service service)
  {
    if (salon == null || service == null) return [];
    return salonService.getRooms(salon.roomIds).where((room) => room.serviceIds.contains(service.id) && room.status == "active");
  }

  List<String> _getQualifiedRoomIdsForIncrement(Increment increment)
  {
    if (selectedService == null) return [];

    Iterable<Room> qualifiedRooms = salonServiceRooms.where((room) => bookingService.find(increment.startTime, room.id) == null);
    return qualifiedRooms.map((r) => r.id).toList();
  }

  List<String> _getQualifiedUserIdsForIncrement(Increment increment)
  {
    if (selectedService == null) return [];

    /// No user selected, return all qualified
    if (selectedUser == null)
    {
      return increment.userStates.keys.where((id) =>
          selectedService.userIds.contains(id) &&
            increment.userStates[id].bookingId == null &&
              increment.userStates[id].state == "open").toList();
    }
    else
    {
      if (!increment.userStates.containsKey(selectedUser.id)) return [];
      UserState us = increment.userStates[selectedUser.id];
      return (us.bookingId == null && us.state == "open") ? [selectedUser.id] : [];
    }
  }

  String selectedRoomId;
  final StreamController<Booking> onTimeSelectController = new StreamController();
  List<Increment> qualifiedIncrements = new List();
  Duration totalDuration = new Duration(seconds: 1);
  List<Room> salonServiceRooms = [];

  @Input('date')
  @override
  void set date(DateTime value) { super.date = value; }

  @Input('disabled')
  void set disabled(bool flag) { super.disabled = flag; }
  
  @Input('salon')
  void set salon(Salon value) { super.selectedSalon = value; }

  @Input('service')
  Service selectedService;

  @Input('serviceAddons')
  List<ServiceAddon> selectedServiceAddons;

  @Input('user')
  void set user(User value) { super.selectedUser = value; }

  @Output('dateClick')
  Stream<DateTime> get onDateClickOutput => onDateClickController.stream;

  @Output('timeSelect')
  Stream<Booking> get onTimeSelect => onTimeSelectController.stream;
}


