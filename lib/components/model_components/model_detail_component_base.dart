import 'package:angular2/angular2.dart';
import 'package:bokain_models/bokain_models.dart' show PhraseService, EditableModel;

abstract class ModelDetailComponentBase
{
  ModelDetailComponentBase(this._formBuilder, this._phrase);

  String getCustomError(String property) => _customErrors[property];

  Map<String, String> _customErrors = new Map();

  PhraseService get phrase => _phrase;
  FormBuilder get formBuilder => _formBuilder;

  EditableModel model;

  ControlGroup form;
  final FormBuilder _formBuilder;
  final PhraseService _phrase;
}