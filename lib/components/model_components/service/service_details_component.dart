// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library service_details_component;

import 'package:angular2/angular2.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show FoValidators, LowercaseDirective, UppercaseDirective;
import 'package:bokain_models/bokain_models.dart' show Service;
import 'package:bokain_admin/services/model/model_service.dart' show ServiceService;
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';

@Component(
    selector: 'bo-service-details',
    templateUrl: 'service_details_component.html',
    styleUrls: const ['service_details_component.css'],
    providers: const [],
    directives: const [FORM_DIRECTIVES, materialDirectives, LowercaseDirective, UppercaseDirective],
    changeDetection: ChangeDetectionStrategy.OnPush,
    preserveWhitespace: false
)

class ServiceDetailsComponent extends ModelDetailComponentBase
{
  ServiceDetailsComponent(this.service, FormBuilder form_builder, PhraseService phrase) : super(service, form_builder, phrase)
  {
    form = formBuilder.group(_controlsConfig);
  }

  @Input('serviceModel')
  void set serviceModel(Service s)
  {
    model = s;
  }

  final ServiceService service;
  final Map<String, dynamic> _controlsConfig =
  {
    "name" : [null, Validators.compose([Validators.required, FoValidators.isName, Validators.maxLength(64)])],
    "category" : [null, Validators.compose([Validators.required, Validators.maxLength(64)])],
    "description" : [null, Validators.compose([Validators.required, Validators.maxLength(512)])],
    "duration" : [null, Validators.compose([Validators.required])],
    "price" : [null, Validators.compose([Validators.required])],
    "status" : ["active", Validators.required]
  };
}
