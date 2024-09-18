
import 'dart:collection';

import 'package:editor_widgets/tabbed_document.dart';

class TabbedLayoutContainer {

  final List<TabbedDocument> _documents;
  late int _activeDocument;
  void Function(UnmodifiableListView<TabbedDocument> documents)? onRefresh;

  TabbedLayoutContainer({List<TabbedDocument>? documents, this.onRefresh}):
        _documents=documents??[],
        _activeDocument=documents!=null ? (documents.isEmpty?-1:0) : -1
  ;

  UnmodifiableListView<TabbedDocument> get documents => UnmodifiableListView(_documents);

  void addDocument(TabbedDocument document) {
    _documents.add(document);
    _activeDocument = _documents.length-1;
    if (onRefresh != null) {
      onRefresh!(documents);
    }
  }

  void clear() {
    _documents.clear();
    _activeDocument = -1;
    if (onRefresh != null) {
      onRefresh!(documents);
    }
  }

  int get activeDocumentIndex {
    return _activeDocument;
  }

  set activeDocumentIndex(int index) {
    if (index == -1 || index>=0 && index<_documents.length) {
      _activeDocument = index;
      if (onRefresh != null) {
        onRefresh!(documents);
      }
    }
  }

  TabbedDocument? get activeDocument {
    if (_activeDocument >= 0 && _activeDocument <= _documents.length) {
      return _documents[_activeDocument];
    }
    return null;
  }

  set activeDocument(TabbedDocument? document) {
    for (int a=0; a<_documents.length; a++) {
      if (_documents[a] == document) {
        _activeDocument = a;
        if (onRefresh != null) {
          onRefresh!(documents);
        }
        break;
      }
    }
  }

}