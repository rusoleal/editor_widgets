import 'dart:collection';

import 'package:editor_widgets/tabbed_document.dart';

/// This class maintains the document list and visible document in a
/// [TabbedLayout] widget
class TabbedLayoutContainer {
  final List<TabbedDocument> _documents;
  late int _activeDocument;

  /// onRefresh event called when ui refresh needed
  void Function(UnmodifiableListView<TabbedDocument> documents)? onRefresh;

  /// default constructor
  TabbedLayoutContainer({List<TabbedDocument>? documents, this.onRefresh})
      : _documents = documents ?? [],
        _activeDocument = documents != null ? (documents.isEmpty ? -1 : 0) : -1;

  /// gets a read-only documents list
  UnmodifiableListView<TabbedDocument> get documents =>
      UnmodifiableListView(_documents);

  /// add a document to the end of the list and set it as active document.
  void addDocument(TabbedDocument document) {
    _documents.add(document);
    _activeDocument = _documents.length - 1;
    if (onRefresh != null) {
      onRefresh!(documents);
    }
  }

  /// clear document list
  void clear() {
    _documents.clear();
    _activeDocument = -1;
    if (onRefresh != null) {
      onRefresh!(documents);
    }
  }

  /// get active document index
  int get activeDocumentIndex {
    return _activeDocument;
  }

  /// set active document index
  set activeDocumentIndex(int index) {
    if (index == -1 || index >= 0 && index < _documents.length) {
      _activeDocument = index;
      if (onRefresh != null) {
        onRefresh!(documents);
      }
    }
  }

  /// get active document if available or null if no document available.
  TabbedDocument? get activeDocument {
    if (_activeDocument >= 0 && _activeDocument <= _documents.length) {
      return _documents[_activeDocument];
    }
    return null;
  }

  /// update active document index
  set activeDocument(TabbedDocument? document) {
    for (int a = 0; a < _documents.length; a++) {
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
