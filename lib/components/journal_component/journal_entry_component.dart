// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart' show JournalService, JournalEntry;

@Component(
    selector: 'bo-journal-entry',
    styleUrls: const ['journal_entry_component.css'],
    templateUrl: 'journal_entry_component.html',
    directives: const [materialDirectives, FoImageFileComponent],
    pipes: const [PhrasePipe]
)

class JournalEntryComponent
{
  JournalEntryComponent(this.journalService, this.phraseService);

  @Input('model')
  JournalEntry journalEntry;

  final PhraseService phraseService;
  final JournalService journalService;
}
