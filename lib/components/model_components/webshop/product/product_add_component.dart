// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of add_component_base;

@Component(
  selector: 'bo-product-add',
  styleUrls: const ['../webshop/product/product_add_component.css'],
  templateUrl: '../webshop/product/product_add_component.html',
  directives: const [CORE_DIRECTIVES, ProductDetailsComponent, materialDirectives],
  pipes: const [PhrasePipe],
)
class ProductAddComponent extends AddComponentBase<Product>
{
  ProductAddComponent(
      this._dynamicPhraseService,
      this._languageService,
      OutputService output_service,
      this._productRoutineService,
      ProductService service) : super(service, output_service);

  @override
  void ngOnInit()
  {
    super.ngOnInit();

    for (Language language in _languageService.cachedModels.values)
    {
      productPhrases[language.iso639_1] = new ProductPhrases();
    }
  }

  @override
  Future<String> push() async
  {
    String id = await super.push();
    for (String language in productPhrases.keys)
    {
      await _dynamicPhraseService.setPhrases(language, "products", id, productPhrases[language].data);
    }
    return id;
  }

  @override
  void cancel()
  {
    /**
     * Remove any created product routines
     */
    for (String id in product.productRoutineIds)
    {
      _productRoutineService.remove(id);
    }

    super.cancel();
  }

  Product get product => model;
  ProductService get productService => _service;

  final Map<String, ProductPhrases> productPhrases = new Map();
  final DynamicPhraseService _dynamicPhraseService;
  final LanguageService _languageService;
  final ProductRoutineService _productRoutineService;
}
