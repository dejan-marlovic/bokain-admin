// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

@Component(
    selector: 'bo-startup-day',
    templateUrl: 'startup_day_component.html',
    styleUrls: const ['startup_day_component.css'],
    directives: const
    [
      CORE_DIRECTIVES,
      FoSelectComponent,
      materialDirectives,
    ],
    pipes: const [PhrasePipe]
)
class StartupDayComponent
{
  StartupDayComponent()
  {
    dayStepOptions = new StringSelectionOptions(
    [
      new FoModel("1"),
      new FoModel("2"),
      new FoModel("3"),
      new FoModel("4"),
      new FoModel("5"),
      new FoModel("6"),
      new FoModel("7"),
      new FoModel("8"),
      new FoModel("9"),
      new FoModel("10")
    ]);
  }

  StringSelectionOptions<FoModel> dayStepOptions;

  @Input('index')
  int index;

  @Input('model')
  StartupDay model = new StartupDay();
}
