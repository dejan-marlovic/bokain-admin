// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show FoSelectComponent;
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/calendar_component/service_picker_component/service_picker_component.dart';
import 'package:bokain_admin/components/calendar_component/booking_add_component/booking_add_component.dart';
import 'package:bokain_admin/components/calendar_component/booking_view_component/booking_view_component.dart';
import 'package:bokain_admin/components/calendar_component/schedule_selection_mode_component/schedule_selection_mode_component.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';

@Component(
    selector: 'bo-calendar',
    styleUrls: const ['calendar_component.css'],
    templateUrl: 'calendar_component.html',
    directives: const
    [
      materialDirectives,
      BookingAddComponent,
      BookingDetailsComponent,
      BookingViewComponent,
      FoSelectComponent,
      ScheduleSelectionModeComponent,
      ServicePickerComponent
    ],
    pipes: const [PhrasePipe]
)
class CalendarComponent implements OnInit
{
  CalendarComponent(this.router, this.bookingService, this.salonService, this.serviceService, this.userService);

  void ngOnInit()
  {
    if (salonService.modelIds.isNotEmpty) selectedSalon = salonService.getModel(salonService.modelIds.first);
    if (userService.modelIds.isNotEmpty) selectedUser = userService.getModel(userService.modelIds.first);
    if (serviceService.modelIds.isNotEmpty) selectedService = serviceService.getModel(serviceService.modelIds.first);

   // calendarService.fetchDay(new DateTime(2017, 6, 16, 8), selectedSalon.id).then(print);

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

  void set calendarState(String value)
  {
    _calendarState = (bookingService.rebookBuffer == null) ? value : "add";

    /// Turn of schedule mode when switcing state
    _scheduleMode = false;
  }

  final BookingService bookingService;
  final SalonService salonService;
  final ServiceService serviceService;
  final UserService userService;
  final Router router;

  Salon selectedSalon;
  Service selectedService;
  List<ServiceAddon> selectedServiceAddons = new List();
  User selectedUser;
  DateTime date = new DateTime.now();
  bool _scheduleMode = false;
  String _calendarState = "view";
  String scheduleState = "open";
  int activeTabIndex = 1;

}

