library add_component_base;

import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:fo_components/fo_components.dart';
import 'details_component_base.dart';

part '../consultation/consultation_add_component.dart';
part '../customer/customer_add_component.dart';
part '../webshop/ingredient/ingredient_add_component.dart';
part '../webshop/product/product_add_component.dart';
part '../webshop/product_category/product_category_add_component.dart';
part '../salon/salon_add_component.dart';
part '../service/service/service_add_component.dart';
part '../service/service_addon/service_addon_add_component.dart';
part '../user/user_add_component.dart';

abstract class AddComponentBase implements OnInit, OnDestroy
{
  AddComponentBase(this._service, this._outputService);

  @override
  void ngOnInit()
  {
    model = _service.createModelInstance(null, null);
  }

  @override
  void ngOnDestroy()
  {
    _onAddController.close();
    _onCancelController.close();
  }

  void cancel()
  {
    _onCancelController.add(null);
  }

  Future<String> push() async
  {
    String id;
    try
    {
      id = await _service.push(model);
      model = _service.createModelInstance(null, null);
      _onAddController.add(id);
    }
    catch (e)
    {
      _outputService.set(e.toString());
      _onAddController.add(null);
    }

    return id;
  }

  ModelBase model;
  final FirebaseServiceBase _service;
  final OutputService _outputService;
  final StreamController<String> _onAddController = new StreamController();
  final StreamController _onCancelController = new StreamController();

  @Output('add')
  Stream<String> get onAddOutput => _onAddController.stream;

  @Output('cancel')
  Stream get onCancelOutput => _onCancelController.stream;
}