// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library model_add_component;

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/services/model_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';

part '../customer_add_component/customer_add_component.dart';
part '../user_add_component/user_add_component.dart';

@Component(
    selector: 'bo-model-add',
    styleUrls: const ['model_add_component.css'],
    templateUrl: 'model_add_component.html',
    directives: const [],
    viewBindings: const [FORM_BINDINGS],
    preserveWhitespace: false
)

class ModelAddComponent
{
  ModelAddComponent(this.phrase, this.modelService, this._formBuilder, this.router)
  {
  }

  ControlGroup form;

  Future<bool> validateUniqueFields(Model model) async
  {
    for (String unique_field in model.uniqueFields)
    {
      Control control = form.controls[unique_field];
      if (control != null)
      {
        if (modelService.findByProperty(unique_field, control.value) != null)
        {
          control.setErrors({"material-input-error" : phrase.get(["_unique_database_value_exists"])});
          return false;
        }
      }
    }
    return true;
  }

  final Router router;
  final FormBuilder _formBuilder;
  final ModelService modelService;
  final PhraseService phrase;
}
