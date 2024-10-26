import 'dart:collection';

import 'package:editor_widgets/tabbed_document.dart';

/// This class maintains the document list and visible document in a
/// [TabbedLayout] widget
class TabbedLayoutContainer {
  final List<TabbedDocument> _documents;
  late int _activeDocument;

  /// onRefresh event called when ui refresh needed
  void Function(UnmodifiableListView<TabbedDocument> documents)? onRefresh;

  /// onSelectedDocument event called when selected document changed.
  void Function(TabbedDocument? document)? onSelectedDocument;

  /// default constructor
  TabbedLayoutContainer({List<TabbedDocument>? documents, this.onRefresh, this.onSelectedDocument})
      : _documents = documents ?? [],
        _activeDocument = documents != null ? (documents.isEmpty ? -1 : 0) : -1;

  /// gets a read-only documents list
  UnmodifiableListView<TabbedDocument> get documents =>
      UnmodifiableListView(_documents);

  /// add a document to the end of the list and set it as active document.
  void addDocument(TabbedDocument document) {
    int index = _documents.indexOf(document);
    if (index==-1) {
      _documents.add(document);
      _activeDocument = _documents.length - 1;
      if (onRefresh != null) {
        onRefresh!(documents);
      }
      if (onSelectedDocument != null) {
        onSelectedDocument!(activeDocument);
      }
    } else {
      _activeDocument = index;
      if (onSelectedDocument != null) {
        onSelectedDocument!(activeDocument);
      }
    }

  }

  void removeDocument(TabbedDocument document) {
    int index = _documents.indexOf(document);
    if (index != -1) {
      _documents.remove(document);
      if (index <= _activeDocument) {
        _activeDocument--;
        if (_activeDocument<0) {
          _activeDocument = 0;
        }
        if (_documents.isEmpty) {
          _activeDocument = -1;
        }
      }
      if (onRefresh != null) {
        onRefresh!(documents);
      }
      if (onSelectedDocument != null) {
        onSelectedDocument!(activeDocument);
      }
    }
  }

  /// clear document list
  void clear() {
    _documents.clear();
    _activeDocument = -1;
    if (onRefresh != null) {
      onRefresh!(documents);
    }
    if (onSelectedDocument != null) {
      onSelectedDocument!(activeDocument);
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
      if (onSelectedDocument != null) {
        onSelectedDocument!(activeDocument);
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
        if (onSelectedDocument != null) {
          onSelectedDocument!(activeDocument);
        }
        break;
      }
    }
  }

  /// go to next document
  void nextDocument() {
    if (_activeDocument == -1) {
      return;
    }

    _activeDocument++;
    if (_activeDocument>=_documents.length) {
      _activeDocument = 0;
    }
    if (onRefresh != null) {
      onRefresh!(documents);
    }
    if (onSelectedDocument != null) {
      onSelectedDocument!(activeDocument);
    }
  }

  /// go to next document
  void priorDocument() {
    if (_activeDocument == -1) {
      return;
    }

    _activeDocument--;
    if (_activeDocument < 0) {
      _activeDocument = _documents.length-1;
    }
    if (onRefresh != null) {
      onRefresh!(documents);
    }
    if (onSelectedDocument != null) {
      onSelectedDocument!(activeDocument);
    }
  }

  /// call onSave event for all open tabs
  Future<void> save() async {

    List<Future> futures = [];

    for (var document in _documents) {
      if (document.onSave != null) {
        futures.add(document.onSave!(document.lastBuiltWidget));
      }
    }
    await Future.wait(futures);
  }
}
