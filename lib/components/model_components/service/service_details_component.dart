// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show LowercaseDirective, UppercaseDirective;
import 'package:bokain_models/bokain_models.dart' show BoValidators, ServiceService, PhraseService, Service;
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';

@Component(
    selector: 'bo-service-details',
    templateUrl: 'service_details_component.html',
    styleUrls: const ['service_details_component.css'],
    providers: const [],
    directives: const [FORM_DIRECTIVES, materialDirectives, materialNumberInputDirectives, LowercaseDirective, UppercaseDirective],
    changeDetection: ChangeDetectionStrategy.OnPush,
    preserveWhitespace: false
)

class ServiceDetailsComponent extends ModelDetailComponentBase
{
  ServiceDetailsComponent(this.serviceService, FormBuilder form_builder, PhraseService phrase) : super(form_builder, phrase)
  {
    form = formBuilder.group(_controlsConfig);
    _updateUniqueControls();
  }

  void _updateUniqueControls()
  {
    form.controls["name"] = new Control("", Validators.compose(
        [
          BoValidators.required,
          BoValidators.isName,
          Validators.maxLength(64),
          BoValidators.unique("name", "_service_with_this_name_already_exists", serviceService, service)
        ]));
  }

  Service get service => model;

  final ServiceService serviceService;
  final Map<String, dynamic> _controlsConfig =
  {
    "category" : [null, Validators.compose([BoValidators.required, Validators.maxLength(64)])],
    "description" : [null, Validators.compose([BoValidators.required, Validators.maxLength(512)])],
    "duration" : [null, Validators.compose([BoValidators.required])],
    "price" : [null, Validators.compose([BoValidators.required])],
    "status" : ["active", Validators.required]
  };

  @Input('serviceModel')
  void set serviceModel(Service s)
  {
    model = s;
    _updateUniqueControls();
  }
}
