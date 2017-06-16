// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show LowercaseDirective, UppercaseDirective;
import 'package:bokain_models/bokain_models.dart' show BoValidators, ServiceService, Service;
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';

@Component(
    selector: 'bo-service-details',
    templateUrl: 'service_details_component.html',
    styleUrls: const ['service_details_component.css'],
    directives: const [FORM_DIRECTIVES, materialDirectives, materialNumberInputDirectives, LowercaseDirective, UppercaseDirective],
    pipes: const [PhrasePipe],
    changeDetection: ChangeDetectionStrategy.OnPush,
)

class ServiceDetailsComponent extends ModelDetailComponentBase implements OnChanges
{
  ServiceDetailsComponent(this.serviceService) : super();

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("service"))
    {
      form = new ControlGroup(
      {
        "name": new Control(service.name,
            Validators.compose(
                [
                  BoValidators.required,
                  BoValidators.isName,
                  Validators.maxLength(64),
                  BoValidators.unique("name", "_service_with_this_name_already_exists", serviceService, service)
                ])),
        "category" : new Control(service.category, Validators.compose([BoValidators.required, Validators.maxLength(64)])),
        "description" : new Control(service.description, Validators.compose([Validators.maxLength(600)])),
        "duration" : new Control(service.durationMinutes, Validators.compose([BoValidators.numericMin(1), BoValidators.numericMax(999999)])),
        "price" : new Control(service.price, Validators.compose([BoValidators.numericMin(0), BoValidators.numericMax(999999)]))
      });
    }
  }

  Service get service => model;
  final ServiceService serviceService;

  @Input('service')
  void set service(Service s) { model = s; }
}
