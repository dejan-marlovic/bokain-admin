// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

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
    ],
    pipes: const [PhrasePipe]
)
class ProductRoutineDetailsComponent
{
  ProductRoutineDetailsComponent()
  {
    form = new ControlGroup(
    {
      "name" : new Control(model.name, Validators.compose(
      [
        FoValidators.required("enter_a_name"),
        Validators.maxLength(32)
      ]))
    });
  }

  ControlGroup form;
  final StreamController<ProductRoutine> onSaveController = new StreamController();

  @Input('disabled')
  bool disabled = false;

  @Input('model')
  ProductRoutine model = new ProductRoutine();

  @Output('save')
  Stream<ProductRoutine> get onSaveOutput => onSaveController.stream;
}
