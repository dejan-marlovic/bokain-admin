// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:bokain_models/bokain_models.dart' show Booking, Increment, User, Room;

@Component(
    selector: 'bo-booking-time',
    styleUrls: const ['booking_time_component.css'],
    templateUrl: 'booking_time_component.html',
    directives: const [],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.OnPush
)
class BookingTimeComponent
{
  BookingTimeComponent();

  @Input('increment')
  Increment increment;

  @Input('user')
  User user;

  @Input('room')
  Room room;

  @Input('duration')
  Duration duration;

  @Output('select')
  Stream<Booking> get select => selectController.stream;

  void onClick()
  {
    Booking booking = new Booking(null);
    booking.startTime = increment.startTime;
    booking.endTime = booking.startTime.add(duration);
    booking.userId = user.id;
    booking.roomId = room.id;
    selectController.add(booking);
  }



  final StreamController<Booking> selectController = new StreamController();
}