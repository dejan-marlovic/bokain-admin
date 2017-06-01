// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show CalendarService, PhraseService, SalonService, UserService, Booking, Salon, User;
import 'package:bokain_admin/components/calendar_component/booking_add_day_component/booking_add_day_component.dart';
import 'package:bokain_admin/components/calendar_component/week_base/week_base.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';

@Component(
    selector: 'bo-booking-add-week',
    styleUrls: const ['../calendar_component.css', '../week_base/week_base.css', 'booking_add_week_component.css'],
    templateUrl: 'booking_add_week_component.html',
    directives: const [materialDirectives, BookingAddDayComponent],
    pipes: const [DatePipe, PhrasePipe],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class BookingAddWeekComponent extends WeekBase implements OnDestroy
{
  BookingAddWeekComponent(PhraseService phrase_service, CalendarService calendar_service,
                       SalonService salon_service, UserService user_service) :
        super(calendar_service, salon_service, user_service, phrase_service);

  void ngOnDestroy()
  {
    onDateClickController.close();
    onTimeSelectController.close();
  }

  @Input('user')
  void set user(User value)
  {
    super.selectedUser = value;
  }

  @Input('salon')
  void set salon(Salon value)
  {
    super.selectedSalon = value;
  }

  @Input('totalDuration')
  Duration totalDuration = new Duration(seconds: 1);

  @Input('date')
  @override
  void set date(DateTime value) { super.date = value; }

  @Input('disabled')
  bool disabled = false;

  @Output('dateClick')
  Stream<DateTime> get onDateClickOutput => onDateClickController.stream;

  @Output('timeSelect')
  Stream<Booking> get onTimeSelectOutput => onTimeSelectController.stream;

  Booking bufferBooking;
  String selectedRoomId;
  final StreamController<DateTime> onDateClickController = new StreamController();
  final StreamController<Booking> onTimeSelectController = new StreamController();
}


