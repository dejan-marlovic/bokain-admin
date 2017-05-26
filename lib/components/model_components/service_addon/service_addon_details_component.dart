// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show LowercaseDirective, UppercaseDirective;
import 'package:bokain_models/bokain_models.dart' show BoValidators, ServiceAddonService, PhraseService, ServiceAddon;
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';

@Component(
    selector: 'bo-service-addon-details',
    templateUrl: 'service_addon_details_component.html',
    styleUrls: const ['service_addon_details_component.css'],
    directives: const [FORM_DIRECTIVES, materialDirectives, materialNumberInputDirectives, LowercaseDirective, UppercaseDirective],
    preserveWhitespace: false
)

class ServiceAddonDetailsComponent extends ModelDetailComponentBase
{
  ServiceAddonDetailsComponent(this.service, FormBuilder form_builder, PhraseService phrase) : super(form_builder, phrase)
  {
    BoValidators.service = service;
    form = formBuilder.group(_controlsConfig);
  }

  @Input('model')
  void set serviceAddonModel(ServiceAddon sa)
  {
    model = sa;
    BoValidators.currentModelId = sa?.id;
  }

  ServiceAddon get serviceAddonModel => model;

  final ServiceAddonService service;
  final Map<String, dynamic> _controlsConfig =
  {
    "name":[null, Validators.compose([BoValidators.required, BoValidators.isName, Validators.maxLength(64), BoValidators.unique("name", "_service_addon_with_this_name_already_exists")])],
    "description":[null, Validators.compose([BoValidators.required, Validators.maxLength(512)])],
    "duration_minutes":[null, Validators.compose([BoValidators.required])],
    "price":[null, Validators.compose([BoValidators.required])],
    "status" : ["active", Validators.required]
  };
}
