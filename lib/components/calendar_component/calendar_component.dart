// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Salon, User;
import 'package:bokain_admin/components/calendar_component/month_calendar_component.dart';
import 'package:bokain_admin/components/calendar_component/week_booking_component.dart';
import 'package:bokain_admin/components/calendar_component/week_schedule_component.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show SalonService, UserService;

@Component(
    selector: 'bo-calendar',
    styleUrls: const ['calendar_component.css'],
    templateUrl: 'calendar_component.html',
    directives: const [materialDirectives, MonthCalendarComponent, WeekBookingComponent, WeekScheduleComponent],
    preserveWhitespace: false
)
class CalendarComponent
{
  CalendarComponent(this.phrase, this.salonService, this.userService)
  {
    userSelection.select(userService.getModelObjects().first);
    salonSelection.select(salonService.getModelObjects().first);
  }

  void openWeekTab(DateTime dt)
  {
    activeTabIndex = 0;
    date = dt;
  }

  User get selectedUser => (userSelection != null && userSelection.isNotEmpty && userSelection.selectedValues.isNotEmpty) ? userSelection.selectedValues.first : null;
  Salon get selectedSalon => (salonSelection != null && salonSelection.isNotEmpty && salonSelection.selectedValues.isNotEmpty) ? salonSelection.selectedValues.first : null;

  final SelectionModel<User> userSelection = new SelectionModel.withList(allowMulti: false);
  final SelectionModel<Salon> salonSelection = new SelectionModel.withList(allowMulti: false);

  final PhraseService phrase;
  final SalonService salonService;
  final UserService userService;

  int activeTabIndex = 0;
  DateTime date = new DateTime.now();

  bool bookingMode = true;
}

