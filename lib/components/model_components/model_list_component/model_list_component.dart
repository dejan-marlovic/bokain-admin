// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library model_list_component;

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/services/model_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';

part '../customer_list_component/customer_list_component.dart';
part '../user_list_component/user_list_component.dart';

@Component(
    selector: 'bo-model-list',
    styleUrls: const ['model_list_component.css'],
    templateUrl: 'model_list_component.html',
    directives: const [materialDirectives],
    preserveWhitespace: false
)

class ModelListComponent
{
  ModelListComponent(this.phrase, this.modelService)
  {
  }

  final ModelService modelService;
  final PhraseService phrase;
}
