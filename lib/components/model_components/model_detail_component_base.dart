import 'package:angular2/angular2.dart';
import 'package:bokain_models/bokain_models.dart' show EditableModel;
import 'package:bokain_admin/services/model/model_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';

abstract class ModelDetailComponentBase
{
  ModelDetailComponentBase(this._modelService, this._formBuilder, this._phrase);

  void validateUniqueField(String property)
  {
    Map<String, Map<String, dynamic>> data = _modelService.findDataByProperty(property, model.data[property]);

    // TODO WTF
    if (data.length > 1 || (data.length == 1 && !model.isEqual(_modelService.createModelInstance(null, data.values.first))))
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

  EditableModel model;

  ControlGroup form;
  final ModelService _modelService;
  final FormBuilder _formBuilder;
  final PhraseService _phrase;
}