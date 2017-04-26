// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Day, Salon, User;
import 'package:bokain_admin/components/booking_add_component/booking_add_component.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService;
import 'package:bokain_admin/services/calendar_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';


@Component(
    selector: 'bo-month-calendar',
    styleUrls: const ['calendar_component.css','month_calendar_component.css'],
    templateUrl: 'month_calendar_component.html',
    directives: const [materialDirectives, BookingAddComponent, BookingDetailsComponent],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.Default
)
class MonthCalendarComponent
{
  MonthCalendarComponent(this.phrase, this.bookingService, this.calendarService)
  {
    date = new DateTime.now();
  }

  void advanceMonth(int count)
  {
    DateTime oldDate = monthDays.first;
    DateTime newDate = oldDate;
    while (newDate.month == oldDate.month)
    {
      newDate = newDate.add(new Duration(days:27*count));
    }
    date = newDate;
    changeMonthOutput.emit(monthDays.first);
  }

  bool isPopulated(DateTime date)
  {
    if (user == null || salon == null) return false;
    Day day = calendarService.getDay(user.id, salon.id, date);
    return day.increments.where((i) => i.state == "open").isNotEmpty;
  }


  @Input('date')
  void set date(DateTime dt)
  {
    monthDays.clear();

    /// First day of month
    DateTime startDate = new DateTime(dt.year, dt.month, 1, 12);
    DateTime iDate = new DateTime(startDate.year, startDate.month, 1, 12);

    while (iDate.month == startDate.month)
    {
      monthDays.add(iDate);
      iDate = iDate.add(const Duration(days: 1));
    }
  }

  String get currentMonth => phrase.get(["month_${monthDays?.first?.month}"]);

  final BookingService bookingService;
  final CalendarService calendarService;
  final PhraseService phrase;
  List<DateTime> monthDays = new List();

  @Input('salon')
  Salon salon;

  @Input('user')
  User user;

  @Output('select')
  EventEmitter<DateTime> select = new EventEmitter();

  @Output('changeMonth')
  EventEmitter<DateTime> changeMonthOutput = new EventEmitter();
}

/*
  // Return increments that has temporal room for the selected service, and where at least one qualified room in the selected
  // salon is available and at least one qualified user is available
  List<Increment> _getBookableIncrements(DateTime date)
  {
    Day day = calendarService.getDay(bookingBuffer.userId, bookingBuffer.salonId, date);

    List<Increment> output = new List();

    if (bookingBuffer.serviceId == null) return output;

    List<Increment> openIncrements = day.increments.where((increment) => increment.state == "open" && increment.bookingId == null).toList(growable: false);
    // The day has no open increments
    if (openIncrements.isEmpty) return output;

    int bookingStripLength = (bookingBuffer.duration.inMinutes / Increment.duration.inMinutes).ceil();
    // The booking takes up too many increments
    if (openIncrements.length < bookingStripLength) return output;

    Salon salon = salonService.getModel(bookingBuffer.salonId);
    // The salon doesn't have any rooms
    if (salon.roomIds.isEmpty) return output;

    for (int i = 0; i < openIncrements.length - (bookingStripLength - 1); i++)
    {
      bool foundOpenStrip = true;
      for (int j = 0; j < bookingStripLength - 1; j++)
      {
        openIncrements[i+j].roomId = _getFirstAvailableRoomId(salon, bookingBuffer.serviceId, openIncrements[i+j].startTime, bookingBuffer.duration);
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

  // Find the first available room in the specified salon, that can host the specified service within the specified time range
  // Returns room_id on success, null if no available room was found
  String _getFirstAvailableRoomId(Salon salon, String service_id, DateTime start_time, Duration duration)
  {
    for (String room_id in salon.roomIds)
    {
      String availableRoomId = room_id;
      Room room = salonService.getRoom(room_id);

      DateTime iTime = start_time;
      DateTime endTime = iTime.add(duration);
      while (iTime.isBefore(endTime))
      {
        availableRoomId =
        (room.serviceIds.contains(service_id) &&
            bookingService.find(iTime, room_id) == null &&
            room_id == availableRoomId) ? room_id : null;

        iTime = iTime.add(Increment.duration);
      }

      // All increments in the specified time range are available for availableRoomId
      if (availableRoomId != null) return availableRoomId;
    }
    return null;
  }
*/
