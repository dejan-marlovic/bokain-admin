// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';

@Component(
    selector: 'bo-service-details',
    templateUrl: 'service_details_component.html',
    styleUrls: const ['service_details_component.css'],
    directives: const [FORM_DIRECTIVES, materialDirectives, materialNumberInputDirectives, LowercaseDirective, UppercaseDirective],
    pipes: const [PhrasePipe],
    changeDetection: ChangeDetectionStrategy.OnPush
)

class ServiceDetailsComponent extends ModelDetailComponentBase implements OnChanges
{
  ServiceDetailsComponent(this.serviceService) : super();


  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("service"))
    {
      Service s = changes["service"].currentValue;

      final FormBuilder formBuilder = new FormBuilder();
      form = formBuilder.group({
          "name" :
          [
            s.name,
            Validators.compose(
                [
                  BoValidators.required,
                  BoValidators.isAlphaNumeric,
                  Validators.maxLength(64),
                  BoValidators.unique("name", "_service_with_this_name_already_exists", serviceService, s)
                ])
          ],
          "category" : [s.category, Validators.compose([BoValidators.required, Validators.maxLength(64)])],
          "description" : [s.description, Validators.maxLength(600)],
          "duration" : [s.durationMinutes, Validators.compose([BoValidators.numericMin(1), BoValidators.numericMax(999999)])],
          "after_margin" : [s.afterMarginMinutes, Validators.compose([BoValidators.numericMin(0), BoValidators.numericMax(999999)])],
          "price" : [s.price, Validators.compose([BoValidators.numericMin(0), BoValidators.numericMax(999999)])]
        });
    }
  }

  Service get service => model;

  final ServiceService serviceService;

  @Input('service')
  void set service(Service s) { model = s; }
}
