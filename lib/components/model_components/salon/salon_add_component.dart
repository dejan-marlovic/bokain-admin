// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library salon_add_component;

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show PhrasePipe, Salon, SalonService;
import 'package:bokain_admin/components/model_components/salon/salon_details_component.dart';

@Component(
    selector: 'bo-salon-add',
    styleUrls: const ['salon_add_component.css'],
    templateUrl: 'salon_add_component.html',
    directives: const [materialDirectives, SalonDetailsComponent],
    pipes: const [PhrasePipe],
)
class SalonAddComponent implements OnDestroy
{
  SalonAddComponent(this.salonService)
  {
    _salon = new Salon();
  }

  void ngOnDestroy()
  {
    _onAddController.close();
  }

  Future push() async
  {
    try
    {
      _onAddController.add(await salonService.push(_salon));
      _salon = new Salon();
    }
    catch (e)
    {
      print(e);
      _onAddController.add(null);
    }
  }

  Salon get salon => _salon;

  Salon _salon;
  final SalonService salonService;
  final StreamController<String> _onAddController = new StreamController();

  @Output('add')
  Stream<String> get onAddOutput => _onAddController.stream;
}
