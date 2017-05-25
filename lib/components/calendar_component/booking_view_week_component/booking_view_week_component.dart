// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/calendar_component/booking_view_day_component/booking_view_day_component.dart';
import 'package:bokain_admin/components/calendar_component/increment_component/increment_component.dart';
import 'package:bokain_admin/components/calendar_component/week_base/week_base.dart';

@Component(
    selector: 'bo-booking-view-week',
    styleUrls: const ['../calendar_component.css', '../week_base/week_base.css', 'booking_view_week_component.css'],
    templateUrl: 'booking_view_week_component.html',
    directives: const
    [
      materialDirectives,
      BookingViewDayComponent,
      IncrementComponent,
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class BookingViewWeekComponent extends WeekBase implements OnDestroy
{
  BookingViewWeekComponent(CalendarService calendar, SalonService salon, UserService user, PhraseService phrase)
      : super(calendar, salon, user, phrase);

  void ngOnDestroy()
  {
    onBookingSelectController.close();
    onDateClickController.close();
  }

  @Input('date')
  @override
  void set date(DateTime value)
  {
    super.date = value;
  }

  @Input('user')
  void set user(User value) { selectedUser = value; }

  @Input('salon')
  void set salon(Salon value) { selectedSalon = value; }

  @Input('disabled')
  bool disabled = false;

  @Input('scheduleMode')
  bool scheduleMode = false;

  @Input('selectedState')
  String selectedState = "open";

  @Output('dateClick')
  Stream<DateTime> get onDateClickOutput => onDateClickController.stream;

  @Output('bookingSelect')
  Stream<Booking> get onBookingSelectOutput => onBookingSelectController.stream;

  final StreamController<Booking> onBookingSelectController = new StreamController();
  final StreamController<DateTime> onDateClickController = new StreamController();
}