// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_admin/components/calendar_component/week_calendar_component.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/editable_model/editable_model_service.dart' show UserService;

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
  CalendarComponent(this.phrase, this.userService)
  {

  }

  String selectedUserId = "";

  final PhraseService phrase;
  final UserService userService;
}
