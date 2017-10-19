// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of add_component_base;

@Component(
  selector: 'bo-product-category-add',
  styleUrls: const ['../webshop/product_category/product_category_add_component.css'],
  templateUrl: '../webshop/product_category/product_category_add_component.html',
  directives: const [CORE_DIRECTIVES, ProductCategoryDetailsComponent, materialDirectives],
  pipes: const [PhrasePipe],
)
class ProductCategoryAddComponent extends AddComponentBase<ProductCategory>
{
  ProductCategoryAddComponent(this._dynamicPhraseService, this._languageService, ProductCategoryService service, OutputService output_service) : super(service, output_service);

  @override
  void ngOnInit()
  {
    super.ngOnInit();

    for (Language language in _languageService.cachedModels.values)
    {
      productCategoryPhrases[language.iso639_1] = new ProductCategoryPhrases();
    }
  }

  ProductCategory get productCategory => model;
  ProductCategoryService get productCategoryService => _service;

  @override
  Future<String> push() async
  {
    String id = await super.push();
    for (String language in productCategoryPhrases.keys)
    {
      await _dynamicPhraseService.setPhrases(language, "product_categories", id, productCategoryPhrases[language].data);
    }
    return id;
  }

  Map<String, ProductCategoryPhrases> productCategoryPhrases = new Map();
  final LanguageService _languageService;
  final DynamicPhraseService _dynamicPhraseService;
}
