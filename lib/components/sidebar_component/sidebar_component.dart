// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show PhraseService;

@Component(
    selector: 'bo-sidebar',
    styleUrls: const ['sidebar_component.css'],
    templateUrl: 'sidebar_component.html',
    directives: const [materialDirectives, ROUTER_DIRECTIVES],
    preserveWhitespace: false
)

class SidebarComponent
{
  SidebarComponent(this.phrase)
  {
    open = false;
  }

  void onMouseOver()
  {
  }

  void onMouseOut()
  {
  }

  final PhraseService phrase;

  @Input('open')
  bool open;
}
