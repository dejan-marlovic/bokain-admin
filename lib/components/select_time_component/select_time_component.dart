// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:bokain_models/bokain_models.dart' show Booking, Day, Increment, Room, Salon;
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/calendar_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService, SalonService, ServiceService, UserService;

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
  SelectTimeComponent(this.phrase, this._bookingService, this.calendarService, this.salonService, this.serviceService, this.userService)
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
    Day day = calendarService.getDay(booking.userId, booking.salonId, date);

    List<Increment> openIncrements = day.increments.where((increment) => increment.state == "open" && increment.bookingId == null).toList(growable: false);
    if (openIncrements.isEmpty) return [];

    int bookingIncrementCount = (booking.duration.inMinutes / Increment.duration.inMinutes).ceil();
    if (openIncrements.length < bookingIncrementCount) return [];

    Salon salon = salonService.getModel(booking.salonId);
    if (salon.roomIds.isEmpty) return [];

    List<Increment> output = new List();
    for (int i = 0; i < openIncrements.length - (bookingIncrementCount - 1); i++)
    {
      bool success = true;
      for (int j = 0; j < bookingIncrementCount - 1; j++)
      {
        if (!openIncrements[i + j].endTime.isAtSameMomentAs(openIncrements[i + j + 1].startTime))
        {
          success = false;
          break;
        }
      }
      if (success)
      {
        DateTime startTime = openIncrements[i].startTime;
        DateTime endTime = openIncrements[i].startTime.add(booking.duration);
        openIncrements[i].roomId = getAvailableRoom(booking.salonId, booking.serviceId, startTime, endTime);
        if (openIncrements[i].roomId != null) output.add(openIncrements[i]);
      }
    }
    return output;
  }


  String getAvailableRoom(String salon_id, String service_id, DateTime time_from, DateTime time_to)
  {
    Salon salon = salonService.getModel(salon_id);

    for (String room_id in salon.roomIds)
    {
      Room room = salonService.getRoom(room_id);
      if (room.serviceIds.contains(service_id))
      {
        bool success = true;
        DateTime iTime = new DateTime(time_from.year, time_from.month, time_from.day, time_from.hour, time_from.minute);
        while (iTime.isBefore(time_to))
        {
          Booking b = _bookingService.find(iTime, room_id);
          if (b != null)
          {
            success = false;
            break;
          }
          iTime = iTime.add(Increment.duration);
        }
        if (success) return room_id;
      }
    }

    return null;
  }


  void onIncrementClick(Increment increment)
  {
    booking.startTime = increment.startTime;
    booking.endTime = booking.startTime.add(booking.duration);
    booking.roomId = increment.roomId;
    select.emit(booking.startTime);
  }


  @Input('booking')
  Booking booking;

  @Output('select')
  EventEmitter<DateTime> select = new EventEmitter();

  List<DateTime> weekdays = new List(7);

  final PhraseService phrase;
  final BookingService _bookingService;
  final CalendarService calendarService;
  final SalonService salonService;
  final ServiceService serviceService;
  final UserService userService;
}
