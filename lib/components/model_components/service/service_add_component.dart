// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart' show Service, ServiceService;
import 'package:bokain_admin/components/model_components/service/service_details_component.dart';

@Component(
    selector: 'bo-service-add',
    styleUrls: const ['service_add_component.css'],
    templateUrl: 'service_add_component.html',
    directives: const [CORE_DIRECTIVES, materialDirectives, ServiceDetailsComponent],
    pipes: const [PhrasePipe]
)
class ServiceAddComponent implements OnDestroy
{
  ServiceAddComponent(this.serviceService)
  {
    service = new Service();
  }

  void ngOnDestroy()
  {
    _onAddController.close();
  }

  Future push() async
  {
    try
    {
      _onAddController.add(await serviceService.push(service));
      service = new Service();
    }
    catch (e)
    {
      print(e);
      _onAddController.add(null);
    }
  }

  Service service;

  final ServiceService serviceService;
  final StreamController<String> _onAddController = new StreamController();

  @Output('add')
  Stream<String> get onAddOutput => _onAddController.stream;
}
