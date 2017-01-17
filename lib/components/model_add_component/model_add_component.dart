// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library model_add_component;

import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/services/model_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';

part '../customer_add_component/customer_add_component.dart';

@Component(
    selector: 'bo-model-add',
    styleUrls: const ['model_add_component.css'],
    templateUrl: 'model_add_component.html',
    directives: const [FORM_DIRECTIVES, materialDirectives],
    viewBindings: const [FORM_BINDINGS],
    preserveWhitespace: false
)

class ModelAddComponent
{
  ModelAddComponent(this.phrase, this.modelService)
  {
  }

  FormBuilder _formBuilder;
  Form _form;

  final ModelService modelService;
  final PhraseService phrase;
}
