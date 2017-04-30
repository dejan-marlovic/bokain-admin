// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Salon, User;
import 'package:bokain_admin/components/calendar_component/month_calendar_component.dart';
import 'package:bokain_admin/components/calendar_component/week_booking_component.dart';
import 'package:bokain_admin/components/calendar_component/week_schedule_component.dart';
import 'package:bokain_admin/services/calendar_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService, SalonService, UserService;

@Component(
    selector: 'bo-calendar',
    styleUrls: const ['calendar_component.css'],
    templateUrl: 'calendar_component.html',
    directives: const [materialDirectives, MonthCalendarComponent, WeekBookingComponent, WeekScheduleComponent],
    preserveWhitespace: false
)
class CalendarComponent
{
  CalendarComponent(this.phrase, this.bookingService, this.calendarService, this.salonService, this.userService);

  void openWeekTab(DateTime dt)
  {
    activeTabIndex = 0;
    date = dt;
  }

  User get selectedUser => (userSelection.selectedValues.isNotEmpty && userOptions.optionsList.contains(userSelection.selectedValues.first)) ? userSelection.selectedValues.first : null;
  Salon get selectedSalon => (salonSelection.isNotEmpty && salonSelection.selectedValues.isNotEmpty) ? salonSelection.selectedValues.first : null;

  final SelectionModel<User> userSelection = new SelectionModel.withList(allowMulti: false);
  final SelectionModel<Salon> salonSelection = new SelectionModel.withList(allowMulti: false);
  final PhraseService phrase;
  final BookingService bookingService;
  final CalendarService calendarService;
  final SalonService salonService;
  final UserService userService;
  int activeTabIndex = 0;
  DateTime date = new DateTime.now();
  bool bookingMode = false;


  SelectionOptions<Salon> get salonOptions => new SelectionOptions([new OptionGroup(salonService.getModelObjects())]);
  SelectionOptions<User> get userOptions
  {
    if (salonOptions.optionsList.isNotEmpty && salonSelection.selectedValues.isNotEmpty)
    {
      return new SelectionOptions([new OptionGroup(userService.getModelObjects(ids: salonSelection.selectedValues.first.userIds))]);
    }
    else return null;
  }

}

