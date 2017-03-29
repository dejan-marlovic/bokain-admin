// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:bokain_models/bokain_models.dart' show Booking, Day, Increment, Room, Salon, Service, ServiceAddon;
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/calendar_service.dart';
import 'package:bokain_admin/services/editable_model/editable_model_service.dart' show SalonService, ServiceService, UserService;

@Component(
    selector: 'bo-select-time',
    styleUrls: const ['select_time_component.css'],
    templateUrl: 'select_time_component.html',
    directives: const [],
    viewBindings: const [],
    preserveWhitespace: false
)
class SelectTimeComponent
{
  SelectTimeComponent(this.phrase, this.calendarService, this.salonService, this.serviceService, this.userService)
  {
    // Monday
    DateTime iDate = new DateTime.now();
    iDate = new DateTime(iDate.year, iDate.month, iDate.day - (iDate.weekday - 1));

    for (int i = 0; i < 7; i++)
    {
      weekdays[i] = iDate;
      iDate = iDate.add(const Duration(days: 1));
    }
  }

  // Return increments that has temporal room for the selected service, and where at least one qualified room in the selected
  // salon is available and at least one qualified user is available
  List<Increment> getAvailableIncrements(DateTime date)
  {
    List<Increment> output = new List();

    Day day = calendarService.getDay(booking.userId, booking.salonId, date);
    List<Increment> availableIncrements = day.increments.where((increment)
    {
      if (increment.state != "open") return false;

      Salon salon = salonService.getModel(booking.salonId);
      for (String room_id in salon.roomIds)
      {
        Room room = salonService.getRoom(room_id);
        if (room != null && room.serviceIds.contains(booking.serviceId) &&
            !calendarService.roomIsBooked(room_id, increment.startTime)) return true;
      }
      return false;
    }).toList(growable: false);

    if (availableIncrements.isEmpty) return output;

    int incrementDurationMinutes = availableIncrements.first.endTime.difference(availableIncrements.first.startTime).inMinutes;

    int bookingIncrementSize = (booking.duration.inMinutes / incrementDurationMinutes).ceil();
    if (availableIncrements.length < bookingIncrementSize) return output;

    for (int i = 0; i < availableIncrements.length - bookingIncrementSize; i++)
    {
      bool qualified = true;
      for (int j = 1; j < bookingIncrementSize - 1; j++)
      {
        if (availableIncrements[i+j].endTime.difference(availableIncrements[i].endTime).inMinutes != j * incrementDurationMinutes)
        {
          qualified = false;
          break;
        }
      }
      if (qualified) output.add(availableIncrements[i]);
    }
    return output;
  }

  void onIncrementClick(Increment increment)
  {
    booking.startTime = increment.startTime;
    booking.endTime = booking.startTime.add(booking.duration);
  }


  @Input('booking')
  Booking booking;

  List<DateTime> weekdays = new List(7);

  final PhraseService phrase;
  final CalendarService calendarService;
  final SalonService salonService;
  final ServiceService serviceService;
  final UserService userService;
}
