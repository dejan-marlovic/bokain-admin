// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show ServiceService, ServiceAddonService, PhraseService, Service, ServiceAddon;
import 'package:bokain_admin/components/associative_table_component/associative_table_component.dart';
import 'package:bokain_admin/components/model_components/service_addon/service_addon_details_component.dart';

@Component(
    selector: 'bo-service-addon-edit',
    styleUrls: const ['service_addon_edit_component.css'],
    templateUrl: 'service_addon_edit_component.html',
    directives: const [materialDirectives, AssociativeTableComponent, ServiceAddonDetailsComponent],
    preserveWhitespace: false
)

class ServiceAddonEditComponent implements OnDestroy
{
  ServiceAddonEditComponent(this.phrase, this.serviceService, this.serviceAddonService);

  void ngOnDestroy()
  {
    _onSaveController.close();
  }

  Future save() async
  {
    if (details.form.valid)
    {
      await serviceAddonService.set(_serviceAddon.id, _serviceAddon);
      _onSaveController.add(_serviceAddon.id);
    }
  }

  void cancel()
  {
    if (_serviceAddon != null) serviceAddon = serviceAddonService.getModel(_serviceAddon.id);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  Future addService(String id) async
  {
    if (!_serviceAddon.serviceIds.contains(id))
    {
      _serviceAddon.serviceIds.add(id);
      await serviceAddonService.patchServices(_serviceAddon);
    }

    Service service = serviceService.getModel(id);
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

    Service service = serviceService.getModel(id);
    if (service != null)
    {
      service.serviceAddonIds.remove(_serviceAddon.id);
      await serviceService.patchServiceAddons(service);
    }
  }

  ServiceAddon get serviceAddon => _serviceAddon;

  @ViewChild('details')
  ServiceAddonDetailsComponent details;

  @Input('model')
  void set serviceAddon(ServiceAddon value)
  {
    _serviceAddon = (value == null) ? null : new ServiceAddon.from(value);
  }

  @Output('save')
  Stream<String> get onSave => _onSaveController.stream;

  ServiceAddon _serviceAddon;

  final ServiceService serviceService;
  final ServiceAddonService serviceAddonService;
  final PhraseService phrase;

  final StreamController<String> _onSaveController = new StreamController();
}
