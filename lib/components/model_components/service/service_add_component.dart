// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show ServiceService, PhraseService, Service;
import 'package:bokain_admin/components/model_components/service/service_details_component.dart';

@Component(
    selector: 'bo-service-add',
    styleUrls: const ['service_add_component.css'],
    templateUrl: 'service_add_component.html',
    directives: const [materialDirectives, ServiceDetailsComponent],
    preserveWhitespace: false
)
class ServiceAddComponent
{
  ServiceAddComponent(this.serviceService, this.phrase)
  {
    _service = new Service();
    _service.status = "active";
  }

  Future push() async
  {
    String id = await serviceService.push(_service);
    _onPushController.add(id);
  }

  Service get service => _service;

  @Output('push')
  Stream<String> get onPush => _onPushController.stream;

  Service _service;
  final ServiceService serviceService;
  final PhraseService phrase;
  final StreamController<String> _onPushController = new StreamController();
}
