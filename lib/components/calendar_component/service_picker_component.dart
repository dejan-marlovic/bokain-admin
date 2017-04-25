// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Service, ServiceAddon;
import 'package:bokain_admin/services/model/model_service.dart' show ServiceAddonService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-service-picker',
    styleUrls: const ['service_picker_component.css'],
    templateUrl: 'service_picker_component.html',
    directives: const [materialDirectives],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.Default
)
class ServicePickerComponent
{
  ServicePickerComponent(this.phrase, this.serviceAddonService)
  {
  }

  SelectionOptions<ServiceAddon> get availableServiceAddonOptions
  {
    if (availableServiceOptions == null || availableServiceOptions.optionsList.isEmpty || serviceSelection.selectedValues.isEmpty) return null;
    else
    {
      Service s = serviceSelection.selectedValues.first;
      List<ServiceAddon> addons = serviceAddonService.getModels(s.serviceAddonIds);
      return new SelectionOptions([new OptionGroup(addons)]);
    }
  }

  String get selectedService
  {
    if (serviceSelection.isEmpty || serviceSelection.selectedValues.isEmpty) return null;
    else return serviceSelection.selectedValues.first.name;
  }

  @Input('serviceOptions')
  SelectionOptions<Service> availableServiceOptions;

  final SelectionModel<Service> serviceSelection = new SelectionModel.withList(allowMulti: false);
  final SelectionModel<ServiceAddon> serviceAddonSelection = new SelectionModel.withList(allowMulti: true);

  final ServiceAddonService serviceAddonService;
  final PhraseService phrase;

  final ItemRenderer<ServiceAddon> addonNameRenderer = (ServiceAddon item) => item.name;
}