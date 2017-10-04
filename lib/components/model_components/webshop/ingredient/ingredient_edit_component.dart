// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of edit_component_base;

@Component(
    selector: 'bo-ingredient-edit',
    styleUrls: const ['../webshop/ingredient/ingredient_edit_component.css'],
    templateUrl: '../webshop/ingredient/ingredient_edit_component.html',
    directives: const
    [
      CORE_DIRECTIVES,
      materialDirectives,
      IngredientDetailsComponent,
      StatusSelectComponent,
    ],
    pipes: const [PhrasePipe]
)

class IngredientEditComponent extends EditComponentBase implements OnChanges
{
  IngredientEditComponent(this._dynamicPhraseService, this._languageService, OutputService output_service, IngredientService service) : super(service, output_service);

  Future ngOnChanges(Map<String, SimpleChange> changes) async
  {
    if (changes.containsKey("model"))
    {
      ingredientPhrases = null;
      Map<String, IngredientPhrases> buffer = new Map();
      for (Language language in _languageService.cachedModels.values)
      {
        buffer[language.iso639_1] = new IngredientPhrases.decode(await _dynamicPhraseService.fetchPhrases(language.iso639_1, "ingredients", model.id));
      }
      ingredientPhrases = new Map.from(buffer);
    }
  }

  @override
  Future save() async
  {
    await super.save();

    for (String language in ingredientPhrases.keys)
    {
      await _dynamicPhraseService.setPhrases(language, "ingredients", ingredient.id, ingredientPhrases[language].data);
    }
  }

  IngredientService get ingredientService => _service;
  Ingredient get ingredient => model;

  Map<String, IngredientPhrases> ingredientPhrases;
  final LanguageService _languageService;
  final DynamicPhraseService _dynamicPhraseService;
}
