// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:fo_components/fo_components.dart';
import 'package:modern_charts_angular_wrapper/modern_charts_angular_wrapper.dart';
import 'package:modern_charts/modern_charts.dart';
import 'package:bokain_models/bokain_models.dart' show UserService;

@Component(
    selector: 'bo-dashboard',
    styleUrls: const ['dashboard_component.css'],
    templateUrl: 'dashboard_component.html',
    directives: const [LineChartComponent],
    pipes: const [PhrasePipe]
)

class DashboardComponent
{
  DashboardComponent(this.userService)
  {

  }

  final DataTable mockData = new DataTable([
    ['Categories', 'Serie 1', 'Serie 2', 'Serie 3'],
    ['Måndag', 1, 3, 5],
    ['Tisdag', 3, 4, 6],
    ['Onsdag', 8, 3, 1],
    ['Torsdag', null, 5, 1],
    ['Fredag', 3, 4, 2],
    ['Lördag', 5, 10, 4],
    ['Söndag', 4, 12, 8]
  ]);

  final UserService userService;
}
