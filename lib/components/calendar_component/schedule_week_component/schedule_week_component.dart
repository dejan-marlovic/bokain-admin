// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/calendar_component/schedule_day_component/schedule_day_component.dart';
import 'package:bokain_admin/components/calendar_component/increment_component/increment_component.dart';
import 'package:bokain_admin/components/calendar_component/week_base/week_base.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';

@Component(
    selector: 'bo-schedule-week',
    styleUrls: const ['../calendar_component.css', '../week_base/week_base.css', 'schedule_week_component.css'],
    templateUrl: 'schedule_week_component.html',
    directives: const
    [
      materialDirectives,
      ScheduleDayComponent,
      IncrementComponent,
    ],
    pipes: const [PhrasePipe],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class ScheduleWeekComponent extends WeekBase implements OnDestroy
{
  ScheduleWeekComponent(CalendarService calendar, SalonService salon, UserService user, PhraseService phrase)
      : super(calendar, salon, user, phrase);

  void ngOnDestroy()
  {
    onDateClickController.close();
  }

  @Input('date')
  @override
  void set date(DateTime value) { super.date = value; }

  @Input('user')
  void set user(User value) { selectedUser = value; }

  @Input('salon')
  void set salon(Salon value) { selectedSalon = value; }

  @Input('disabled')
  bool disabled = false;

  @Input('selectedState')
  String selectedState = "open";

  @Output('dateClick')
  Stream<DateTime> get onDateClickOutput => onDateClickController.stream;

  final StreamController<DateTime> onDateClickController = new StreamController();
}