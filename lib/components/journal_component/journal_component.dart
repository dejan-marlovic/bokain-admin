// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future;
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

  /*
  Future uploadImage(String data_base64, int index) async
  {
    String url = await journalService.uploadImage(data_base64);

    if (index > bufferEntry.imageURIs.length - 1) bufferEntry.imageURIs.add(url);
    else bufferEntry.imageURIs[index] = url;
  }
*/
  Future push() async
  {
    await journalService.push(bufferEntry);
    bufferEntry.imageURIs.clear();
    bufferEntry.commentsInternal = bufferEntry.commentsExternal = "";
    imageCounter.clear();
  }

  void popImage()
  {
    if (imageCounter.isNotEmpty) imageCounter.removeLast();
  }

  void appendImage()
  {
    if (imageCounter.length < imageSources.length) imageCounter.add(imageCounter.length);
  }

  @Input('customerId')
  void set customerId(String value)
  {
    _customerId = value;
    bufferEntry = new JournalEntry(_customerId);
    imageCounter.clear();
  }

  List<JournalEntry> get journalEntries => journalService.getModelObjects(ids: (_customerService.getModel(_customerId) as Customer).journalEntryIds);
  JournalEntry bufferEntry;
  List<int> imageCounter = new List();
  List<String> imageSources = new List(20);
  final CustomerService _customerService;
  final JournalService journalService;
  final PhraseService phraseService;
  String _customerId;


  String source = "";
}
