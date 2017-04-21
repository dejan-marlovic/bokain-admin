// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Booking, Salon, User;
import 'package:bokain_admin/components/calendar_component/month_calendar_component.dart';
import 'package:bokain_admin/components/calendar_component/week_calendar_component.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show IdModel, SalonService, UserService;

@Component(
    selector: 'bo-calendar',
    styleUrls: const ['calendar_component.css'],
    templateUrl: 'calendar_component.html',
    directives: const [materialDirectives, MonthCalendarComponent, WeekCalendarComponent],
    preserveWhitespace: false
)
class CalendarComponent
{
  CalendarComponent(this.phrase, this.salonService, this.userService)
  {
    userSelection.selectionChanges.listen(onUserSelectionChange);
    salonSelection.selectionChanges.listen(onSalonSelectionChange);

    userSelection.select(userService.modelOptions.optionsList.first);
    salonSelection.select(salonService.modelOptions.optionsList.first);
  }

  void onSalonSelectionChange(List<SelectionChangeRecord<IdModel>> e)
  {
    if (e.isNotEmpty && e.first.added.isNotEmpty)
    {
      booking.salonId = e.first.added.first.id;
      booking.startTime = booking.endTime = booking.roomId = null;
    }
    else booking.startTime = booking.endTime = booking.roomId = null;
  }

  void onUserSelectionChange(List<SelectionChangeRecord<IdModel>> e)
  {
    if (e.isNotEmpty && e.first.added.isNotEmpty)
    {
      booking.userId = e.first.added.first.id;
      booking.startTime = booking.endTime = booking.roomId = null;
    }
    else booking.startTime = booking.endTime = booking.roomId = null;
  }

  void openWeek(DateTime dt)
  {
    activeTabIndex = 0;
    date = dt;
  }

  User get selectedUser => userService.getModel(booking.userId);

  Salon get selectedSalon => salonService.getModel(booking.salonId);

  final SelectionModel<IdModel> userSelection = new SelectionModel.withList(allowMulti: false);
  final SelectionModel<IdModel> salonSelection = new SelectionModel.withList(allowMulti: false);

  final PhraseService phrase;
  final SalonService salonService;
  final UserService userService;

  int activeTabIndex = 0;
  Booking booking = new Booking();
  DateTime date = new DateTime.now();
}

