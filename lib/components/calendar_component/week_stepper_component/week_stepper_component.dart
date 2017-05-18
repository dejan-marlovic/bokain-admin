// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show PhraseService;

@Component(
    selector: 'bo-week-stepper',
    styleUrls: const ['week_stepper_component.css'],
    templateUrl: 'week_stepper_component.html',
    directives: const [materialDirectives],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class WeekStepperComponent
{
  WeekStepperComponent(this.phraseService);

  Future advanceWeek(int week_count) async
  {
    for (int i = 0; i < 7; i++)
    {
      weekDates[i] = weekDates[i].add(new Duration(days: 7 * week_count));
    }
    currentWeek = _getWeekOf(weekDates.first);
    _onDateChangeController.add(weekDates.first);
  }

  String get currentMonth => phraseService.get(["month_${weekDates.first.month}"]);

  @Output('dateChange')
  Stream<DateTime> get onDateChangeOutput => _onDateChangeController.stream;

  @Input('date')
  void set date(DateTime value)
  {
    DateTime iDate = new DateTime(value.year, value.month, value.day, 12);
    // Monday
    iDate = new DateTime(iDate.year, iDate.month, iDate.day - (iDate.weekday - 1), 12);
    currentWeek = _getWeekOf(iDate);
    for (int i = 0; i < 7; i++)
    {
      weekDates[i] = iDate;
      iDate = iDate.add(const Duration(days: 1));
    }
  }

  int currentWeek;
  List<DateTime> weekDates = new List(7);
  final PhraseService phraseService;
  final StreamController<DateTime> _onDateChangeController = new StreamController();

  int _getWeekOf(DateTime date)
  {
    /// Convert any date to the monday of that dates' week
    DateTime mondayDate = date.add(new Duration(days:-(date.weekday-1)));
    DateTime firstMondayOfYear = new DateTime(date.year);
    while (firstMondayOfYear.weekday != 1) firstMondayOfYear = firstMondayOfYear.add(const Duration(days:1));
    Duration difference = mondayDate.difference(firstMondayOfYear);
    return (difference.inDays ~/ 7).toInt() + 1;
  }
}