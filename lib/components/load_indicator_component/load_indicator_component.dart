// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';

@Component(
    selector: 'bo-load-indicator',
    styleUrls: const ['load_indicator_component.css'],
    templateUrl: 'load_indicator_component.html',
    directives: const [materialDirectives],
    providers: const [],
    preserveWhitespace: false
)

class LoadIndicatorComponent
{
  LoadIndicatorComponent()
  {

  }

  @Input('show')
  bool show = false;
}
