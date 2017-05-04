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
    selector: 'bo-service-addon-add',
    styleUrls: const ['service_addon_add_component.css'],
    templateUrl: 'service_addon_add_component.html',
    directives: const [materialDirectives, ServiceAddonDetailsComponent],
    preserveWhitespace: false
)
class ServiceAddonAddComponent
{
  ServiceAddonAddComponent(this.service, this.phrase)
  {
    model = new ServiceAddon.empty();
    model.status = "active";
  }

  Future push() async
  {
    String id = await service.push(model);
    _onPushController.add(id);
  }

  @Output('push')
  Stream<String> get onPush => _onPushController.stream;


  ServiceAddon model;
  final ServiceAddonService service;
  final PhraseService phrase;
  final StreamController<String> _onPushController = new StreamController();
}
