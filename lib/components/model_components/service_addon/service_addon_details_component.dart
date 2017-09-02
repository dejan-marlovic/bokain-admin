// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';

@Component(
    selector: 'bo-service-addon-details',
    templateUrl: 'service_addon_details_component.html',
    styleUrls: const ['service_addon_details_component.css'],
    directives: const [CORE_DIRECTIVES, formDirectives, materialDirectives, materialNumberInputDirectives, LowercaseDirective, UppercaseDirective],
    pipes: const [PhrasePipe]
)

class ServiceAddonDetailsComponent extends ModelDetailComponentBase implements OnChanges
{
  ServiceAddonDetailsComponent(this.serviceAddonService, FormBuilder form_builder) : super();

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("serviceAddon"))
    {
      form = new ControlGroup(
      {
        "name" : new Control(serviceAddon.name,
        Validators.compose(
          [
            FoValidators.required("enter_a_name"),
            Validators.maxLength(64),
            BoValidators.unique("name", "service_addon_with_this_name_already_exists", serviceAddonService, serviceAddon)
          ])),
        "description" : new Control(serviceAddon.description, Validators.compose([Validators.maxLength(600)])),
        "duration_minutes" : new Control(serviceAddon.durationMinutesStr, Validators.compose(
            [FoValidators.required("enter_a_duration"), FoValidators.numeric])),
        "price" : new Control(serviceAddon.priceStr, Validators.compose(
            [FoValidators.required("enter_a_price"), FoValidators.numeric]))
      });
    }
  }

  ServiceAddon get serviceAddon => model;

  final ServiceAddonService serviceAddonService;

  @Input('serviceAddon')
  void set serviceAddon(ServiceAddon sa) { model = sa; }
}
