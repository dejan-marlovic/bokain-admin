// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of edit_component_base;

@Component(
    selector: 'bo-product-category-edit',
    styleUrls: const ['../webshop/product_category/product_category_edit_component.css'],
    templateUrl: '../webshop/product_category/product_category_edit_component.html',
    directives: const
    [
      CORE_DIRECTIVES,
      materialDirectives,
      ProductCategoryDetailsComponent,
      StatusSelectComponent,
    ],
    pipes: const [PhrasePipe]
)

class ProductCategoryEditComponent extends EditComponentBase<ProductCategory> implements OnChanges
{
  ProductCategoryEditComponent(this._dynamicPhraseService, this._languageService, OutputService output_service, ProductCategoryService service) : super(service, output_service);

  Future ngOnChanges(Map<String, SimpleChange> changes) async
  {
    if (changes.containsKey("model"))
    {
      productCategoryPhrases = null;
      Map<String, ProductCategoryPhrases> buffer = new Map();
      for (Language language in _languageService.cachedModels.values)
      {
        buffer[language.iso639_1] = new ProductCategoryPhrases.decode(await _dynamicPhraseService.fetchPhrases(language.iso639_1, "product_categories", model.id));
      }
      productCategoryPhrases = new Map.from(buffer);
    }
  }

  @override
  Future save() async
  {
    await super.save();

    for (String language in productCategoryPhrases.keys)
    {
      await _dynamicPhraseService.setPhrases(language, "product_categories", productCategory.id, productCategoryPhrases[language].data);
    }
  }

  ProductCategoryService get productCategoryService => _service;
  ProductCategory get productCategory => model;

  Map<String, ProductCategoryPhrases> productCategoryPhrases;
  final LanguageService _languageService;
  final DynamicPhraseService _dynamicPhraseService;
}
