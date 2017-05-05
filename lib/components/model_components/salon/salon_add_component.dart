// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library salon_add_component;

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show SalonService, PhraseService, Salon;
import 'package:bokain_admin/components/model_components/salon/salon_details_component.dart';

@Component(
    selector: 'bo-salon-add',
    styleUrls: const ['salon_add_component.css'],
    templateUrl: 'salon_add_component.html',
    directives: const [materialDirectives, SalonDetailsComponent],
    preserveWhitespace: false
)
class SalonAddComponent
{
  SalonAddComponent(this.salonService, this.phrase)
  {
    salon = new Salon();
    salon.status = "active";
  }

  Future push() async
  {
    String id = await salonService.push(salon);
    _onPushController.add(id);
  }

  @Output('push')
  Stream<String> get onPush => _onPushController.stream;

  Salon salon;
  final SalonService salonService;
  final PhraseService phrase;

  final StreamController<String> _onPushController = new StreamController();
}
