// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show Service;
import 'package:bokain_admin/components/model_components/service/service_details_component.dart';
import 'package:bokain_admin/components/associative_table_component/associated_table_component.dart';
import 'package:bokain_admin/services/model/model_service.dart' show ServiceService, ServiceAddonService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-service-edit',
    styleUrls: const ['service_edit_component.css'],
    templateUrl: 'service_edit_component.html',
    directives: const [materialDirectives, AssociativeTableComponent, ServiceDetailsComponent],
    preserveWhitespace: false
)

class ServiceEditComponent
{
  ServiceEditComponent(this.phrase, this.serviceService, this.addonService);

  Future save() async
  {
    if (details.form.valid)
    {
      _bufferService = new Service.from(_service);
      await serviceService.set(_service.id, _service);
      _onSaveController.add(_service.id);
    }
  }

  void cancel()
  {
    _service = new Service.from(_bufferService);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  void addServiceAddon(String service_addon_id)
  {
    _service.serviceAddonIds.add(service_addon_id);

    /*
    save();
    */
    /// TODO patch service addons
  }

  void removeServiceAddon(String service_addon_id)
  {
    _service.serviceAddonIds.remove(service_addon_id);
    /*
    save();
    */
    // TODO patch service addons
  }

  Service get service => _service;

  @ViewChild('details')
  ServiceDetailsComponent details;

  @Input('model')
  void set service(Service value)
  {
    _service = value;
    _bufferService = (_service == null) ? null : new Service.from(_service);
  }

  @Output('save')
  Stream<String> get onSave => _onSaveController.stream;

  Service _service, _bufferService;
  final ServiceService serviceService;
  final ServiceAddonService addonService;
  final PhraseService phrase;
  final StreamController<String> _onSaveController = new StreamController();
}
