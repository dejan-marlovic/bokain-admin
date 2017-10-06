// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'startup_day_component.dart';

@Component(
    selector: 'bo-product-routine-details',
    templateUrl: 'product_routine_details_component.html',
    styleUrls: const ['product_routine_details_component.css'],
    directives: const
    [
      CORE_DIRECTIVES,
      formDirectives,
      FoMultiInputComponent,
      FoSelectComponent,
      materialDirectives,
      StartupDayComponent
    ],
    pipes: const [PhrasePipe]
)
class ProductRoutineDetailsComponent
{
  ProductRoutineDetailsComponent(this._phraseService)
  {
    form = new ControlGroup(
    {
      "name" : new Control(model.name, Validators.compose(
      [
        FoValidators.required("enter_a_name"),
        Validators.maxLength(32)
      ])),
      "daily_routine_morning" : new Control(model.dailyRoutineMorning, Validators.compose(
      [
        Validators.maxLength(3000)
      ]
      )),
      "daily_routine_mid_day" : new Control(model.dailyRoutineMidDay, Validators.compose(
      [
        Validators.maxLength(3000)
      ]
      )),
      "daily_routine_evening" : new Control(model.dailyRoutineEvening, Validators.compose(
      [
        Validators.maxLength(3000)
      ]
      )),
      "weekly_routine" : new Control(model.weeklyRoutine, Validators.compose(
      [
        Validators.maxLength(3000)
      ]
      )),
    });

    dayStepOptions = new StringSelectionOptions(
    [
      new FoModel("1", _phraseService.get("every_1_days")),
      new FoModel("2", _phraseService.get("every_2_days")),
      new FoModel("3", _phraseService.get("every_3_days")),
      new FoModel("4", _phraseService.get("every_4_days")),
      new FoModel("5", _phraseService.get("every_5_days")),
      new FoModel("6", _phraseService.get("every_6_days")),
      new FoModel("7", _phraseService.get("every_7_days")),
      new FoModel("8", _phraseService.get("every_8_days")),
      new FoModel("9", _phraseService.get("every_9_days")),
      new FoModel("10", _phraseService.get("every_10_days")),
    ]);
  }

  String get saveText => (model?.id == null) ? "add" : "update";

  ControlGroup form;
  StringSelectionOptions<FoModel> dayStepOptions;
  final StreamController<String> onDeleteController = new StreamController();
  final StreamController<ProductRoutine> onSaveController = new StreamController();
  final PhraseService _phraseService;

  @Input('disabled')
  bool disabled = false;

  @Input('model')
  ProductRoutine model = new ProductRoutine();

  @Output('delete')
  Stream<String> get onDeleteOutput => onDeleteController.stream;

  @Output('save')
  Stream<ProductRoutine> get onSaveOutput => onSaveController.stream;
}
