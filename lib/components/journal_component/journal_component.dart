// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future;
import 'dart:math' show min;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import '../journal_component/journal_entry_component.dart';

@Component(
    selector: 'bo-journal',
    styleUrls: const ['journal_component.css'],
    templateUrl: 'journal_component.html',
    directives: const [CORE_DIRECTIVES, FoImageFileComponent, JournalEntryComponent, materialDirectives],
    pipes: const [PhrasePipe]
)
class JournalComponent implements OnChanges
{
  JournalComponent(this._customerService, this.journalService);

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("customer"))
    {
      journalService.cancelStreaming();
      journalService.cachedModels.clear();
      journalService.streamAll(new FirebaseQueryParams(searchProperty: "customer_id", searchValue: customer.id));
      bufferEntry = new JournalEntry(null, customer.id);
    }

  }

  Future push() async
  {
    for (String source in imageSources)
    {
      if (source != null && source.isNotEmpty)
      {
        bufferEntry.imageURIs.add(await journalService.uploadImage(source));
      }
    }

    customer.journalEntryIds.add(await journalService.push(bufferEntry));
    await _customerService.patchJournalEntries(customer);


    bufferEntry.imageURIs.clear();
    bufferEntry.commentsInternal = bufferEntry.commentsExternal = "";
    imageSources = new List(maxImages);
  }

  List<int> get imageList
  {
    String last = imageSources.lastWhere((src) => src != null && src.isNotEmpty && src != "", orElse: () => "");
    int index = min(imageSources.indexOf(last), maxImages - 2);
    return new List.generate(index + 2, (i) => i);
  }

  JournalEntry bufferEntry;
  List<String> imageSources = new List(maxImages);
  final CustomerService _customerService;
  final JournalService journalService;
  String source = "";

  static final int maxImages = 20;

  @Input('customer')
  Customer customer;
}
