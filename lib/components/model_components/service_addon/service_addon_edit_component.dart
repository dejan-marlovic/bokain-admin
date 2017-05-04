// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show ServiceAddon;
import 'package:bokain_admin/components/model_components/service_addon/service_addon_details_component.dart';
import 'package:bokain_admin/services/model/model_service.dart' show ServiceAddonService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-service-addon-edit',
    styleUrls: const ['service_addon_edit_component.css'],
    templateUrl: 'service_addon_edit_component.html',
    directives: const [materialDirectives, ServiceAddonDetailsComponent],
    preserveWhitespace: false
)

class ServiceAddonEditComponent
{
  ServiceAddonEditComponent(this.phrase, this.serviceAddonService);

  Future save() async
  {
    if (details.form.valid)
    {
      _bufferServiceAddon = new ServiceAddon.from(_serviceAddon);
      await serviceAddonService.set(_serviceAddon.id, _serviceAddon);

      _onSaveController.add(_serviceAddon.id);
    }
  }

  void cancel()
  {
    _serviceAddon = new ServiceAddon.from(_bufferServiceAddon);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  ServiceAddon get serviceAddon => _serviceAddon;

  @ViewChild('details')
  ServiceAddonDetailsComponent details;

  @Input('model')
  void set model(ServiceAddon value)
  {
    _serviceAddon = value;
    _bufferServiceAddon = (_serviceAddon == null) ? null : new ServiceAddon.from(_serviceAddon);
  }

  @Output('save')
  Stream<String> get onSave => _onSaveController.stream;

  ServiceAddon _serviceAddon, _bufferServiceAddon;

  final ServiceAddonService serviceAddonService;
  final PhraseService phrase;

  final StreamController<String> _onSaveController = new StreamController();
}
