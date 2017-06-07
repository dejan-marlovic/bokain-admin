// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart' show GlyphComponent;
import 'package:bokain_models/bokain_models.dart' show Increment, UserState;
import 'package:bokain_admin/components/calendar_component/increment_component/increment_component.dart';

@Component(
    selector: 'bo-increment-group',
    styleUrls: const ['increment_group_component.css'],
    templateUrl: 'increment_group_component.html',
    directives: const [GlyphComponent, IncrementComponent],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class IncrementGroupComponent implements OnChanges
{
  IncrementGroupComponent();

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
  }

  void onMouseDown()
  {

  }

  void onMouseEnter()
  {

  }

  bool isHighlighted(Increment increment)
  {
    return false;
  }

  @Input('increments')
  List<Increment> increments = new List();

  @Input('userId')
  String userId;
}