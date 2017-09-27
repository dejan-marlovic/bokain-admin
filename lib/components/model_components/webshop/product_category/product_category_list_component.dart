// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of list_component_base;

@Component(
    selector: 'bo-product-category-list',
    styleUrls: const ['../webshop/product_category/product_category_list_component.css'],
    templateUrl: '../webshop/product_category/product_category_list_component.html',
    directives: const [CORE_DIRECTIVES, DataTableComponent, FoModalComponent, materialDirectives, ProductCategoryAddComponent, ProductCategoryEditComponent],
    pipes: const [PhrasePipe]
)
class ProductCategoryListComponent extends ListComponentBase
{
  ProductCategoryListComponent(ProductCategoryService service) : super(service);
}
