// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:bokain_models/bokain_models.dart' show UserService;
import 'package:bokain_admin/pipes/phrase_pipe.dart';

@Component(
    selector: 'bo-dashboard',
    styleUrls: const ['dashboard_component.css'],
    templateUrl: 'dashboard_component.html',
    pipes: const [PhrasePipe]
)

class DashboardComponent
{
  DashboardComponent(this.userService)
  {

  }

  final UserService userService;
}
