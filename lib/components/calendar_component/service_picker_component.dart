// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream;
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
    serviceSelection.selectionChanges.listen((_) => serviceAddonSelection.clear());
  }

  SelectionOptions<ServiceAddon> get availableServiceAddonOptions
  {
    if (availableServiceOptions == null || availableServiceOptions.optionsList.isEmpty || serviceSelection.selectedValues.isEmpty) return null;
    else
    {
      Service s = serviceSelection.selectedValues.first;
      List<ServiceAddon> addons = serviceAddonService.getModelObjects(ids: s.serviceAddonIds);
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

  @Input('service')
  void set service(Service value)
  {
    if (value == null) serviceSelection.clear();
    else serviceSelection.select(value);
  }

  @Output('serviceChange')
  Stream<Service> get serviceChange => serviceSelection.selectionChanges.map((e) => (e.isEmpty || e.first.added.isEmpty) ? null : e.first.added.first);

  @Output('addonsChange')
  Stream<List<ServiceAddon>> get serviceAddonChange => serviceAddonSelection.selectionChanges.map((e) => serviceAddonSelection.isEmpty || serviceAddonSelection.selectedValues.isEmpty ? null : serviceAddonSelection.selectedValues.toList(growable: false));

  final SelectionModel<Service> serviceSelection = new SelectionModel.withList(allowMulti: false);
  final SelectionModel<ServiceAddon> serviceAddonSelection = new SelectionModel.withList(allowMulti: true);
  final ServiceAddonService serviceAddonService;
  final PhraseService phrase;
  final ItemRenderer<ServiceAddon> addonNameRenderer = (ServiceAddon item) => item.name;
}