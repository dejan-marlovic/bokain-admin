// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future;
import 'dart:math' show min;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show ImageFileComponent;
import 'package:bokain_models/bokain_models.dart' show PhraseService, JournalEntry, JournalService, CustomerService, Customer;
import 'package:bokain_admin/components/journal_component/journal_entry_component.dart';

@Component(
    selector: 'bo-journal',
    styleUrls: const ['journal_component.css'],
    templateUrl: 'journal_component.html',
    directives: const [materialDirectives, ImageFileComponent, JournalEntryComponent],
    preserveWhitespace: false
)

class JournalComponent
{
  JournalComponent(this._customerService, this.journalService, this.phraseService);

  Future push() async
  {
    for (String source in imageSources)
    {
      if (source != null && source.isNotEmpty)
      {
        String base64 = source.substring("data:image/jpeg;base64,".length);
        bufferEntry.imageURIs.add(await journalService.uploadImage(base64));
      }
    }


    await journalService.push(bufferEntry);
    bufferEntry.imageURIs.clear();
    bufferEntry.commentsInternal = bufferEntry.commentsExternal = "";
    imageSources = new List(maxImages);
  }

  @Input('customerId')
  void set customerId(String value)
  {
    _customerId = value;
    bufferEntry = new JournalEntry(_customerId);
  }


  List<int> get imageList
  {
    String last = imageSources.lastWhere((src) => src != null && src.isNotEmpty && src != "", orElse: () => "");
    int index = min(imageSources.indexOf(last), maxImages - 2);
    return new List.generate(index + 2, (i) => i);
  }

  List<JournalEntry> get journalEntries => journalService.getModelObjects(ids: (_customerService.getModel(_customerId) as Customer).journalEntryIds);
  JournalEntry bufferEntry;
  List<String> imageSources = new List(maxImages);
  final CustomerService _customerService;
  final JournalService journalService;
  final PhraseService phraseService;
  String _customerId;


  String source = "";

  static final int maxImages = 20;
}
