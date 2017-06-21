import 'package:angular2/angular2.dart';
import 'package:bokain_models/bokain_models.dart' show EditableModel;

abstract class ModelDetailComponentBase
{
  ModelDetailComponentBase();

  EditableModel model;
  ControlGroup form = new ControlGroup({});

  bool get valid => (form == null) ? false : form.valid;
}