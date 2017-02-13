import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'package:bokain_models/bokain_models.dart' show EditableModel;
import 'package:bokain_admin/services/editable_model/editable_model_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';

class ModelDetailComponentBase
{
  ModelDetailComponentBase(this._modelService, this._formBuilder, this._phrase);

  void validateUniqueField(String property)
  {
    Iterable<EditableModel> matches = _modelService.findByProperty(property, model.properties[property]);
    if (matches.length > 1 || (matches.length == 1 && matches.first != model))
    {
      Map<String, String> params = {"property_pronounced" : _phrase.get(["${property}_pronounced"], capitalize_first: false)};
      _customErrors[property] = _phrase.get(["_unique_database_value_exists"], params: params);
      form.controls[property].setErrors({"custom_error" : _customErrors[property]});
    }
    else
    {
      _customErrors[property] = null;
      form.controls[property].errors?.remove("custom_error");
    }
  }

  String getCustomError(String property) => _customErrors[property];

  Map<String, String> _customErrors = new Map();

  PhraseService get phrase => _phrase;
  FormBuilder get formBuilder => _formBuilder;

  @Input('model')
  EditableModel model;

  ControlGroup form;
  final EditableModelService _modelService;
  final FormBuilder _formBuilder;
  final PhraseService _phrase;
}