library edit_component_base;

import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_calendar/bokain_calendar.dart';
//import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_models/bokain_models.dart';
//import 'package:firebase/firebase.dart' as firebase;
import 'package:fo_components/fo_components.dart';
import '../../associative_table_component/associative_table_component.dart';
import '../../journal_component/journal_component.dart';
import '../../status_select_component/status_select_component.dart';

import 'details_component_base.dart';

part '../consultation/consultation_edit_component.dart';
part '../customer/customer_edit_component.dart';
part '../webshop/ingredient/ingredient_edit_component.dart';
part '../webshop/product/product_edit_component.dart';
part '../webshop/product_category/product_category_edit_component.dart';
part '../salon/salon_edit_component.dart';
part '../service/service/service_edit_component.dart';
part '../service/service_addon/service_addon_edit_component.dart';
part '../user/user_edit_component.dart';

abstract class EditComponentBase implements OnDestroy
{
  EditComponentBase(this._service, this._outputService);

  @override
  void ngOnDestroy()
  {
    _onSaveController.close();
    _onCancelController.close();
  }

  Future save() async
  {
    try
    {
      await _service.set(model);
      _onSaveController.add(model.id);
    }
    catch (e)
    {
      await cancel();
      _outputService.set(e.toString());
      _onSaveController.add(null);
    }
  }

  Future cancel() async
  {
    model = await _service.fetch(model?.id, force: true);
    _onCancelController.add(model?.id);
  }

  final FirebaseServiceBase _service;
  final OutputService _outputService;
  final StreamController<String> _onSaveController = new StreamController();
  final StreamController<String> _onCancelController = new StreamController();

  @Input('model')
  ModelBase model;

  @Output('save')
  Stream<String> get onSave => _onSaveController.stream;

  @Output('cancel')
  Stream<String> get onCancel => _onCancelController.stream;
}