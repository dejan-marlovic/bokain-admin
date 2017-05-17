// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show CalendarService, PhraseService, BookingService, SalonService, UserService, Salon, User;
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/calendar_component/month_calendar_component.dart';
import 'package:bokain_admin/components/calendar_component/booking_add_component.dart';
import 'package:bokain_admin/components/calendar_component/booking_schedule_component.dart';
import 'package:bokain_admin/components/calendar_component/week_booking_component.dart';
import 'package:bokain_admin/components/calendar_component/week_schedule_component.dart';

@Component(
    selector: 'bo-calendar',
    styleUrls: const ['calendar_component.css'],
    templateUrl: 'calendar_component.html',
    directives: const [materialDirectives, BookingDetailsComponent, MonthCalendarComponent, BookingAddComponent, BookingScheduleComponent, WeekBookingComponent, WeekScheduleComponent],
    preserveWhitespace: false
)
class CalendarComponent implements OnInit
{
  CalendarComponent(this.phrase, this.bookingService, this.calendarService, this.salonService, this.userService)
  {
    salonSelection.selectionChanges.listen((_)
    {
      if (userOptions != null && userOptions.isNotEmpty) userSelection.select(userOptions.optionsList.first);
      else userSelection.clear();
    });
  }

  void ngOnInit()
  {
    if (salonOptions != null && salonOptions.isNotEmpty) salonSelection.select(salonOptions.optionsList.first);
  }

  User get selectedUser => (userSelection.selectedValues.isNotEmpty) ? userSelection.selectedValues.first : null;
  Salon get selectedSalon => (salonSelection.selectedValues.isNotEmpty) ? salonSelection.selectedValues.first : null;

  bool get scheduleMode => _scheduleMode;

  void set scheduleMode(bool value) { _scheduleMode = value; }

  SelectionOptions<Salon> get salonOptions => new SelectionOptions([new OptionGroup(salonService.getModels())]);
  SelectionOptions<User> get userOptions
  {
    if (salonOptions.optionsList.isNotEmpty && salonSelection.selectedValues.isNotEmpty)
    {
      return new SelectionOptions([new OptionGroup(userService.getModels(salonSelection.selectedValues.first.userIds))]);
    }
    else return null;
  }

  void onBookingAdd(String event)
  {
    calendarState = "view";
  }

  final SelectionModel<User> userSelection = new SelectionModel.withList(allowMulti: false);
  final SelectionModel<Salon> salonSelection = new SelectionModel.withList(allowMulti: false);
  final PhraseService phrase;
  final BookingService bookingService;
  final CalendarService calendarService;
  final SalonService salonService;
  final UserService userService;
  DateTime date = new DateTime.now();
  bool _scheduleMode = false;
  String calendarState = "view";
  int activeTabIndex = 0;

}

