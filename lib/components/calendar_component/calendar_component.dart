// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_admin/components/calendar_component/week_calendar_component.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show SalonService, UserService;

@Component(
    selector: 'bo-calendar',
    styleUrls: const ['calendar_component.css'],
    templateUrl: 'calendar_component.html',
    directives: const [materialDirectives, WeekCalendarComponent],
    providers: const [],
    preserveWhitespace: false
)
class CalendarComponent
{
  CalendarComponent(this.phrase, this.salonService, this.userService)
  {
    selectedUserId = userService.data.keys.first;
    selectedSalonId = salonService.data.keys.first;
  }

  String selectedUserId = "";
  String selectedSalonId = "";

  final PhraseService phrase;
  final SalonService salonService;
  final UserService userService;
}
