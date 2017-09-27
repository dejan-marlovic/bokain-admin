// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';

@Component(
    selector: 'bo-journal-entry',
    styleUrls: const ['journal_entry_component.css'],
    templateUrl: 'journal_entry_component.html',
    directives: const [CORE_DIRECTIVES, FoImageFileComponent, materialDirectives],
    pipes: const [DatePipe, PhrasePipe]
)

class JournalEntryComponent
{
  JournalEntryComponent(this.journalService);

  Future onCancel() async
  {
    entry = await journalService.fetch(entry.id, force: true);
  }

  Future onSave() async => await journalService.set(entry.id, entry);

  final JournalService journalService;

  @Input('model')
  JournalEntry entry;
}
