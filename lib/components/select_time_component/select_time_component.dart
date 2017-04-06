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
    // The day has no open increments
    if (openIncrements.isEmpty) return [];

    int bookingStripLength = (booking.duration.inMinutes / Increment.duration.inMinutes).ceil();
    // The booking takes up too many increments
    if (openIncrements.length < bookingStripLength) return [];

    Salon salon = salonService.getModel(booking.salonId);
    // The salon doesn't have any rooms
    if (salon.roomIds.isEmpty) return [];


    List<Increment> output = new List();
    for (int i = 0; i < openIncrements.length - (bookingStripLength - 1); i++)
    {
      bool foundOpenStrip = true;
      for (int j = 0; j < bookingStripLength - 1; j++)
      {
        openIncrements[i+j].roomId = _getFirstAvailableRoomId(salon, booking.serviceId, openIncrements[i + j].startTime);
        if (openIncrements[i+j].roomId == null || !openIncrements[i+j].endTime.isAtSameMomentAs(openIncrements[i+j+1].startTime))
        {
          foundOpenStrip = false;
          break;
        }
      }
      if (foundOpenStrip == true) output.add(openIncrements[i]);
    }
    return output;
  }

  // Find the first available room in the specified salon, that can host the specified service during the specified time increment
  // Returns room_id on success, null if no available room was found
  String _getFirstAvailableRoomId(Salon salon, String service_id, DateTime time)
  {
    for (String room_id in salon.roomIds)
    {
      Room room = salonService.getRoom(room_id);
      if (room.serviceIds.contains(service_id) && _bookingService.find(time, room_id) == null) return room_id;
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
