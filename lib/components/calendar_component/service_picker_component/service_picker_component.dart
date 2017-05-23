// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show SalonService, ServiceService, ServiceAddonService, PhraseService, User, Salon, Service, ServiceAddon;

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
  ServicePickerComponent(this.phrase, this._salonService, this._serviceService, this._serviceAddonService)
  {
    serviceSelection.selectionChanges.listen((_) => serviceAddonSelection.clear());
  }

  SelectionOptions<ServiceAddon> get serviceAddonOptions
  {
    if (serviceOptions == null || serviceOptions.optionsList.isEmpty || serviceSelection.selectedValues.isEmpty) return null;
    else
    {
      Service s = serviceSelection.selectedValues.first;
      List<ServiceAddon> addons = _serviceAddonService.getModelsAsList(s.serviceAddonIds);
      return new SelectionOptions([new OptionGroup(addons)]);
    }
  }

  String get selectedService
  {
    if (serviceSelection.isEmpty || serviceSelection.selectedValues.isEmpty) return null;
    else return serviceSelection.selectedValues.first.name;
  }

  SelectionOptions<Service> get serviceOptions
  {
    if (salon == null) return null;
    else if (user == null)
    {
      // Filter so that only services supported by the salon are listed
      List<String> ids = _salonService.getServiceIds(salon);
      List<Service> services = _serviceService.getModelsAsList(ids);
      services.sort(_sortAlpha);
      return new SelectionOptions([new OptionGroup(services)]);
    }
    else
    {
      // Filter so that only services supported by the user/salon are listed
      List<String> ids = _salonService.getServiceIds(salon).where(user.serviceIds.contains).toList();
      List<Service> services = _serviceService.getModelsAsList(ids);
      services.sort(_sortAlpha);
      return new SelectionOptions([new OptionGroup(services)]);
    }
  }

  int _sortAlpha(Service a, Service b) => a.name.compareTo(b.name);

  final SelectionModel<Service> serviceSelection = new SelectionModel.withList(allowMulti: false);
  final SelectionModel<ServiceAddon> serviceAddonSelection = new SelectionModel.withList(allowMulti: true);
  final SalonService _salonService;
  final ServiceService _serviceService;
  final ServiceAddonService _serviceAddonService;
  final PhraseService phrase;
  final ItemRenderer<ServiceAddon> addonNameRenderer = (ServiceAddon item) => item.name;

  @Input('salon')
  Salon salon;

  @Input('service')
  void set service(Service value)
  {
    if (value == null) serviceSelection.clear();
    else serviceSelection.select(value);
  }

  @Input('user')
  User user;

  @Output('serviceChange')
  Stream<Service> get serviceChange
  {
    return serviceSelection.selectionChanges.map((e)
      => (e.isEmpty || e.first.added.isEmpty) ? null : e.first.added.first);
  }

  @Output('addonsChange')
  Stream<List<ServiceAddon>> get serviceAddonChange => serviceAddonSelection.selectionChanges.map((e)
    => serviceAddonSelection.isEmpty || serviceAddonSelection.selectedValues.isEmpty ?
    null : serviceAddonSelection.selectedValues.toList(growable: false));
}