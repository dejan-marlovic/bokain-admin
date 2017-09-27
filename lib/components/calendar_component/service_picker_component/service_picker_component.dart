// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';

@Component(
    selector: 'bo-service-picker',
    styleUrls: const ['service_picker_component.css'],
    templateUrl: 'service_picker_component.html',
    directives: const [CORE_DIRECTIVES, FoMultiSelectComponent, FoSelectComponent, materialDirectives],
    pipes: const [PhrasePipe]
)
class ServicePickerComponent implements OnChanges, OnDestroy
{
  ServicePickerComponent(this._salonService, this._serviceService, this.serviceAddonService);

  Future ngOnChanges(Map<String, SimpleChange> changes) async
  {
    if (changes.containsKey("salon") || changes.containsKey("user"))
    {
      service = null;
      serviceOptions = null;
      serviceAddons = null;
      serviceAddonOptions = null;

      if (salon != null)
      {
        List<String> serviceIds = _salonService.getServiceIds(salon).toList(growable: true);
        if (user != null) serviceIds.removeWhere((String id) => !user.serviceIds.contains(id));

        if (serviceIds.isNotEmpty)
        {
          Map<String, Service> services = await _serviceService.getMany(serviceIds);

          if (services.isNotEmpty)
          {
            service = services.values.first;
            serviceOptions = new StringSelectionOptions(services.values.toList(growable: false));

            Map<String, ServiceAddon> addons = await serviceAddonService.fetchMany(service.serviceAddonIds);
            serviceAddonOptions = new StringSelectionOptions(addons.values.toList(growable: false));
            serviceAddons = new List();

            if (!onServiceChangeController.isClosed) onServiceChangeController.add(service);
          }
        }
      }
    }
  }

  void ngOnDestroy()
  {
    onServiceAddonsChangeController.close();
    onServiceChangeController.close();
  }

  Future onSelectedServiceChange(Service value) async
  {
    service = value;
    if (!onServiceChangeController.isClosed) onServiceChangeController.add(service);

    Map<String, ServiceAddon> addons = await serviceAddonService.fetchMany(service.serviceAddonIds);
    serviceAddonOptions = new StringSelectionOptions(addons.values.toList(growable: false));
    serviceAddons = new List();

    if (!onServiceChangeController.isClosed) onServiceChangeController.add(service);
    if (!onServiceAddonsChangeController.isClosed) onServiceAddonsChangeController.add(serviceAddons);
  }

  void onSelectedServiceAddonsChange(List<ServiceAddon> value)
  {
    serviceAddons = value;
    if (!onServiceAddonsChangeController.isClosed) onServiceAddonsChangeController.add(serviceAddons);
  }



  Service service;
  List<ServiceAddon> serviceAddons;
  StringSelectionOptions<Service> serviceOptions;
  StringSelectionOptions<ServiceAddon> serviceAddonOptions;
  final SalonService _salonService;
  final ServiceService _serviceService;
  final ServiceAddonService serviceAddonService;
  final StreamController<List<ServiceAddon>> onServiceAddonsChangeController = new StreamController();
  final StreamController<Service> onServiceChangeController = new StreamController();

  @Input('salon')
  Salon salon;

  @Input('user')
  User user;

  @Output('serviceChange')
  Stream<Service> get onServiceChangeOutput => onServiceChangeController.stream;

  @Output('serviceAddonsChange')
  Stream<List<ServiceAddon>> get onServiceAddonsChangeOutput => onServiceAddonsChangeController.stream;
}