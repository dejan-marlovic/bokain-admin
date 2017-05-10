// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show ServiceService, ServiceAddonService, PhraseService, Service, ServiceAddon;
import 'package:bokain_admin/components/model_components/service/service_details_component.dart';
import 'package:bokain_admin/components/associative_table_component/associative_table_component.dart';

@Component(
    selector: 'bo-service-edit',
    styleUrls: const ['service_edit_component.css'],
    templateUrl: 'service_edit_component.html',
    directives: const [materialDirectives, AssociativeTableComponent, ServiceDetailsComponent],
    preserveWhitespace: false
)

class ServiceEditComponent implements OnDestroy
{
  ServiceEditComponent(this.phrase, this.serviceService, this.addonService);

  void ngOnDestroy()
  {
    _onSaveController.close();
  }

  Future save() async
  {
    if (details.form.valid)
    {
      await serviceService.set(_service.id, _service);
      _onSaveController.add(_service.id);
    }
  }

  void cancel()
  {
    if (service != null) service = serviceService.getModel(service.id);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  Future addServiceAddon(String id) async
  {
    if (!_service.serviceAddonIds.contains(id))
    {
      _service.serviceAddonIds.add(id);
      await serviceService.patchServiceAddons(_service);
    }

    ServiceAddon addon = addonService.getModel(id);
    if (addon != null && !addon.serviceIds.contains(_service.id))
    {
      addon.serviceIds.add(_service.id);
      await addonService.patchServices(addon);
    }
  }

  Future removeServiceAddon(String id) async
  {
    _service.serviceAddonIds.remove(id);
    await serviceService.patchServiceAddons(_service);

    ServiceAddon addon = addonService.getModel(id);
    if (addon != null)
    {
      addon.serviceIds.remove(_service.id);
      await addonService.patchServices(addon);
    }
  }

  Service get service => _service;

  @ViewChild('details')
  ServiceDetailsComponent details;

  @Input('model')
  void set service(Service value)
  {
    _service = (value == null) ? null : new Service.from(value);
  }

  @Output('save')
  Stream<String> get onSave => _onSaveController.stream;

  Service _service;
  final ServiceService serviceService;
  final ServiceAddonService addonService;
  final PhraseService phrase;
  final StreamController<String> _onSaveController = new StreamController();
}
