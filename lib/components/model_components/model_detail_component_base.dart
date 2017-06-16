import 'package:angular2/angular2.dart';
import 'package:bokain_models/bokain_models.dart' show EditableModel;

abstract class ModelDetailComponentBase
{
  ModelDetailComponentBase();

  EditableModel model;
  ControlGroup form;

  bool get valid => (form == null) ? false : form.valid;
}