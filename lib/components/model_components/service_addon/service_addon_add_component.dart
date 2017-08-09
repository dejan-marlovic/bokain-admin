// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show PhrasePipe, ServiceAddon, ServiceAddonService;
import 'package:bokain_admin/components/model_components/service_addon/service_addon_details_component.dart';

@Component(
    selector: 'bo-service-addon-add',
    styleUrls: const ['service_addon_add_component.css'],
    templateUrl: 'service_addon_add_component.html',
    directives: const [materialDirectives, ServiceAddonDetailsComponent],
    pipes : const [PhrasePipe]
)
class ServiceAddonAddComponent implements OnDestroy
{
  ServiceAddonAddComponent(this.serviceAddonService)
  {
    serviceAddon = new ServiceAddon();
  }

  void ngOnDestroy()
  {
    _onAddController.close();
  }

  Future push() async
  {
    try
    {
      _onAddController.add(await serviceAddonService.push(serviceAddon));
      serviceAddon = new ServiceAddon();
    }
    catch(e)
    {
      print(e);
      _onAddController.add(null);
    }

  }

  ServiceAddon serviceAddon;
  final ServiceAddonService serviceAddonService;
  final StreamController<String> _onAddController = new StreamController();

  @Output('add')
  Stream<String> get onAddOutput => _onAddController.stream;
}
