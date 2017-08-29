// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

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
    pipes: const [PhrasePipe]
)
class CalendarComponent implements OnInit
{
  CalendarComponent(this.bookingService, this.calendarService, this.salonService, this.serviceService, this.userService);

  void ngOnInit()
  {
    if (salonService.modelIds.isNotEmpty) selectedSalon = salonService.getModel(salonService.modelIds.first);
    if (userService.modelIds.isNotEmpty) selectedUser = userService.getModel(userService.modelIds.first);
    if (serviceService.modelIds.isNotEmpty) selectedService = serviceService.getModel(serviceService.modelIds.first);
  }

  bool get scheduleMode => _scheduleMode;

  void set scheduleMode(bool value) { _scheduleMode = value; }

  void onBookingDone(Booking booking)
  {
    _calendarState = "view";
  }

  String get calendarState
  {
    return (bookingService.rebookBuffer == null) ? _calendarState : "add";
  }

  DateTime get date => _date;

  Salon get selectedSalon => _selectedSalon;

  void set calendarState(String value)
  {
    _calendarState = (bookingService.rebookBuffer == null) ? value : "add";

    /// Turn of schedule mode when switching state
    _scheduleMode = false;
  }

  void set date(DateTime value)
  {
    _date = value;
  }

  void set selectedSalon(Salon value)
  {
    _selectedSalon = value;
  }

  String get userSelectionNullText => (calendarState == "add" && scheduleMode == false) ? "anyone" : "choose";

  final BookingService bookingService;
  final CalendarService calendarService;
  final SalonService salonService;
  final ServiceService serviceService;
  final UserService userService;

  Salon _selectedSalon;
  Service selectedService;
  List<ServiceAddon> selectedServiceAddons = new List();
  User selectedUser;
  DateTime _date = new DateTime.now();
  bool _scheduleMode = false;
  String _calendarState = "view";
  String scheduleState = "open";
  int activeTabIndex = 1;
}

