// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show User, Salon, Booking;
import 'package:bokain_admin/components/calendar_component/month_calendar_component.dart';
import 'package:bokain_admin/components/calendar_component/week_calendar_component.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show ModelOption, SalonService, UserService;

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
    userOptions = new SelectionOptions([new OptionGroup(userService.getModelOptions())]);
    salonOptions = new SelectionOptions([new OptionGroup(salonService.getModelOptions())]);

    userSelection.selectionChanges.listen(onUserSelectionChange);
    salonSelection.selectionChanges.listen(onSalonSelectionChange);

    userSelection.select(userOptions.optionsList.first);
    salonSelection.select(salonOptions.optionsList.first);
  }

  void onSalonSelectionChange(List<SelectionChangeRecord<ModelOption>> e)
  {
    if (e.isNotEmpty && e.first.added.isNotEmpty)
    {
      booking.salonId = e.first.added.first.id;
      booking.startTime = null;
      booking.endTime = null;
      booking.roomId = null;
    }
  }

  void onUserSelectionChange(List<SelectionChangeRecord<ModelOption>> e)
  {
    if (e.isNotEmpty && e.first.added.isNotEmpty)
    {
      booking.userId = e.first.added.first.id;
      booking.startTime = null;
      booking.endTime = null;
      booking.roomId = null;
    }
  }

  void openWeek(DateTime dt)
  {
    activeTabIndex = 0;
    date = dt;
  }

  final SelectionModel<ModelOption> userSelection = new SelectionModel.withList(allowMulti: false);
  final SelectionModel<ModelOption> salonSelection = new SelectionModel.withList(allowMulti: false);
  SelectionOptions<ModelOption> userOptions;
  SelectionOptions<ModelOption> salonOptions;

  final PhraseService phrase;
  final SalonService salonService;
  final UserService userService;

  String get userSelectLabel => userSelection.selectedValues.isEmpty ? phrase.get(['user_plural']) : userSelection.selectedValues.first.model.toString();
  String get salonSelectLabel => salonSelection.selectedValues.isEmpty ? phrase.get(['salon_plural']) : salonSelection.selectedValues.first.model.toString();

  int activeTabIndex = 0;
  Booking booking = new Booking();
  DateTime date = new DateTime.now();
}

