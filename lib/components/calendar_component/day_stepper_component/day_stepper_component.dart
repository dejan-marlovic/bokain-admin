// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show PhraseService;

@Component(
    selector: 'bo-day-stepper',
    styleUrls: const ['day_stepper_component.css'],
    templateUrl: 'day_stepper_component.html',
    directives: const [materialDirectives],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class DayStepperComponent implements OnDestroy
{
  DayStepperComponent(this.phraseService);

  void ngOnDestroy()
  {
    _onDateChangeController.close();
  }

  Future advance(int day_count) async
  {
    date = date.add(new Duration(days: day_count));
    _onDateChangeController.add(date);
  }

  @Output('dateChange')
  Stream<DateTime> get onDateChangeOutput => _onDateChangeController.stream;

  @Input('date')
  DateTime date;

  List<DateTime> get surroundingDays
  {
    DateTime first = date.add(const Duration(days: -14));
    DateTime last = date.add(const Duration(days: 14));
    DateTime iDate = first;
    List<DateTime> output = new List();

    while (iDate.isBefore(last))
    {
      output.add(iDate);
      iDate = iDate.add(const Duration(days: 1));
    }

    return output;
  }


  final PhraseService phraseService;
  final StreamController<DateTime> _onDateChangeController = new StreamController();
}