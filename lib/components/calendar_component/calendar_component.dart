// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Salon, User;
import 'package:bokain_admin/components/calendar_component/month_calendar_component.dart';
import 'package:bokain_admin/components/calendar_component/week_calendar_component.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show SalonService, UserService;

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
    userSelection = new SelectionModel.withList(allowMulti: false);
    salonSelection = new SelectionModel.withList(allowMulti: false);
    final OptionGroup<User> usersGroup = new OptionGroup(userService.getModels(userService.data.keys.toList(growable: false)) as List<User>);
    final OptionGroup<Salon> salonsGroup = new OptionGroup(salonService.getModels(salonService.data.keys.toList(growable: false)) as List<Salon>);
    users = new SelectionOptions([usersGroup]);
    salons = new SelectionOptions([salonsGroup]);

 //   selectedUserId = userService.data.keys.first;
 //   selectedSalonId = salonService.data.keys.first;

  }

  void openWeek(DateTime dt)
  {
    activeTabIndex = 0;
    date = dt;
  }

  SelectionModel<User> userSelection;
  SelectionModel<Salon> salonSelection;
  SelectionOptions<User> users;
  SelectionOptions<Salon> salons;

  String get selectedUserId => userService.data.keys.first;
  String get selectedSalonId => salonService.data.keys.first;

  final PhraseService phrase;
  final SalonService salonService;
  final UserService userService;

  int activeTabIndex = 0;


  DateTime date = new DateTime.now();
}
