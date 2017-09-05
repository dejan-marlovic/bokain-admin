// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_calendar/bokain_calendar.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/calendar_component/booking_add_component/booking_add_component.dart';
import 'package:bokain_admin/components/calendar_component/service_picker_component/service_picker_component.dart';
import 'package:bokain_admin/components/calendar_component/schedule_selection_mode_component/schedule_selection_mode_component.dart';

@Component(
    selector: 'bo-calendar',
    styleUrls: const ['calendar_component.css'],
    templateUrl: 'calendar_component.html',
    directives: const
    [
      BookingAddComponent,
      BookingDetailsComponent,
      BookingViewComponent,
      CORE_DIRECTIVES,
      FoSelectComponent,
      materialDirectives,
      ScheduleSelectionModeComponent,
      ServicePickerComponent
    ],
    providers: const [],
    pipes: const [PhrasePipe]
)
class CalendarComponent implements OnInit
{
  CalendarComponent(this.bookingService, this.salonService, this.serviceService, this.userService);

  Future ngOnInit() async
  {
    if (salonService.streamedModels.isNotEmpty) salon = salonService.streamedModels.values.first;
    if (userService.streamedModels.isNotEmpty) user = userService.streamedModels.values.first;
    if (serviceService.streamedModels.isNotEmpty) service = serviceService.streamedModels.values.first;
  }

  void onBookingDone(Booking booking)
  {
    _calendarState = "view";
  }

  String get calendarState
  {
    return (bookingService.rebookBuffer == null) ? _calendarState : "add";
  }

  void set calendarState(String value)
  {
    _calendarState = (bookingService.rebookBuffer == null) ? value : "add";

    /// Turn of schedule mode when switching state
    scheduleMode = false;
  }

  StringSelectionOptions<Salon> get salonOptions => new StringSelectionOptions(salonService.streamedModels.values.toList(growable: false));
  StringSelectionOptions<User> get userOptions => new StringSelectionOptions(userService.getMany(salon.userIds).values.toList(growable: false));

  String get userSelectionNullText => (calendarState == "add" && scheduleMode == false) ? "anyone" : "choose";

  final BookingService bookingService;
  final SalonService salonService;
  final ServiceService serviceService;
  final UserService userService;

  Salon salon;
  Service service;
  List<ServiceAddon> serviceAddons = new List();
  User user;
  DateTime date = new DateTime.now();
  bool scheduleMode = false;
  String _calendarState = "view";
  String scheduleState = "open";
  int activeTabIndex = 1;
}

