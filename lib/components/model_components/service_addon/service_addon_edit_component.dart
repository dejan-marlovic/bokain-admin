// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/associative_table_component/associative_table_component.dart';
import 'package:bokain_admin/components/model_components/service_addon/service_addon_details_component.dart';

@Component(
    selector: 'bo-service-addon-edit',
    styleUrls: const ['service_addon_edit_component.css'],
    templateUrl: 'service_addon_edit_component.html',
    directives: const [AssociativeTableComponent, CORE_DIRECTIVES, materialDirectives, ServiceAddonDetailsComponent],
    pipes: const [PhrasePipe]
)

class ServiceAddonEditComponent implements OnDestroy
{
  ServiceAddonEditComponent(this.serviceService, this.serviceAddonService);

  void ngOnDestroy()
  {
    _onSaveController.close();
  }

  Future save() async
  {
    await serviceAddonService.set(_serviceAddon.id, _serviceAddon);
    _onSaveController.add(_serviceAddon.id);
  }

  void cancel()
  {
    serviceAddon = serviceAddonService.get(_serviceAddon?.id);
  }

  Future addService(String id) async
  {
    if (!_serviceAddon.serviceIds.contains(id))
    {
      _serviceAddon.serviceIds.add(id);
      await serviceAddonService.patchServices(_serviceAddon);
    }

    Service service = serviceService.get(id);
    if (service != null && !service.serviceAddonIds.contains(_serviceAddon.id))
    {
      service.serviceAddonIds.add(_serviceAddon.id);
      await serviceService.patchServiceAddons(service);
    }
  }

  Future removeService(String id) async
  {
    _serviceAddon.serviceIds.remove(id);
    await serviceAddonService.patchServices(_serviceAddon);

    Service service = serviceService.get(id);
    if (service != null)
    {
      service.serviceAddonIds.remove(_serviceAddon.id);
      await serviceService.patchServiceAddons(service);
    }
  }

  ServiceAddon get serviceAddon => _serviceAddon;

  ServiceAddon _serviceAddon;
  final ServiceService serviceService;
  final ServiceAddonService serviceAddonService;
  final StreamController<String> _onSaveController = new StreamController();

  @Input('serviceAddon')
  void set serviceAddon(ServiceAddon value)
  {
    _serviceAddon = (value == null) ? null : new ServiceAddon.from(value);
  }

  @Output('save')
  Stream<String> get onSaveOutput => _onSaveController.stream;
}
