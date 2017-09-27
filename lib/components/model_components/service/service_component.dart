// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import '../base/list_component_base.dart';

@Component(
    selector: 'bo-service',
    styleUrls: const ['service_component.css'],
    templateUrl: 'service_component.html',
    directives: const [CORE_DIRECTIVES, materialDirectives, ServiceListComponent, ServiceAddonListComponent],
    pipes: const [PhrasePipe]
)
class ServiceComponent
{
  ServiceComponent();
}
