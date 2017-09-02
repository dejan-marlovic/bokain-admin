// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';

@Component(
    selector: 'bo-service-picker',
    styleUrls: const ['service_picker_component.css'],
    templateUrl: 'service_picker_component.html',
    directives: const [CORE_DIRECTIVES, FoMultiSelectComponent, FoSelectComponent, materialDirectives],
    pipes: const [PhrasePipe],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class ServicePickerComponent implements OnChanges, OnDestroy
{
  ServicePickerComponent(this._salonService, this._serviceService, this.serviceAddonService);

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("salon"))
    {
      selectedService = null;
      selectedServiceAddons = null;
      serviceOptions = null;
      serviceAddonOptions = null;

      if (salon != null)
      {
        List<String> serviceIds = _salonService.getServiceIds(salon);
        if (serviceIds.isNotEmpty)
        {
          selectedService = _serviceService.get(serviceIds.first);
          selectedServiceAddons = null;

          serviceOptions = new StringSelectionOptions(_serviceService.getMany(serviceIds).values.toList(growable: false));
          List<ServiceAddon> addons = serviceAddonService.getMany(selectedService.serviceAddonIds).values;
          if (addons.isNotEmpty) serviceAddonOptions = new StringSelectionOptions(addons);
        }
      }
    }
    else if (changes.containsKey("service"))
    {
      selectedServiceAddons = null;
      List<ServiceAddon> addons = serviceAddonService.getMany(selectedService.serviceAddonIds).values.toList(growable: false);
      if (addons.isNotEmpty) serviceAddonOptions = new StringSelectionOptions(addons);
    }
  }

  void ngOnDestroy()
  {
    _onServiceAddonChangeController.close();
    _onServiceChangeController.close();
  }

  Service get selectedService => _selectedService;

  List<ServiceAddon> get selectedServiceAddons => _selectedServiceAddons;


  void set selectedService(Service value)
  {
    _selectedService = value;
    _onServiceChangeController.add(_selectedService);
  }

  void set selectedServiceAddons(List<ServiceAddon> value)
  {
    _selectedServiceAddons = value;
    _onServiceAddonChangeController.add(_selectedServiceAddons);
  }

  final SalonService _salonService;
  final ServiceService _serviceService;
  final ServiceAddonService serviceAddonService;
  Service _selectedService;
  List<ServiceAddon> _selectedServiceAddons;

  StringSelectionOptions<Service> serviceOptions = new StringSelectionOptions([]);
  StringSelectionOptions<ServiceAddon> serviceAddonOptions = new StringSelectionOptions([]);

  final StreamController<List<ServiceAddon>> _onServiceAddonChangeController = new StreamController();
  final StreamController<Service> _onServiceChangeController = new StreamController();

  @Input('salon')
  Salon salon;

  @Input('service')
  void set serviceExternal(Service value) { _selectedService = value; }

  @Input('serviceAddons')
  void set serviceAddonsExternal(List<ServiceAddon> value) { _selectedServiceAddons = value; }

  @Input('user')
  User user;

  @Output('serviceChange')
  Stream<Service> get onServiceChangeOutput => _onServiceChangeController.stream;

  @Output('serviceAddonsChange')
  Stream<List<ServiceAddon>> get onServiceAddonsChangeOutput => _onServiceAddonChangeController.stream;
}