
import 'package:core/presentation/utils/html_transformer/transform_configuration.dart';
import 'package:html/dom.dart';

/// Transforms the HTML DOM.
abstract class DomTransformer {

  const DomTransformer();

  /// Uses the `DOM` [document] and specified [message] to transform the `document`.
  ///
  /// All changes will be visible to subsequent transformers.
  void process(Document document, String message, TransformConfiguration configuration);

  /// Adds a HEAD element if necessary
  void ensureDocumentHeadIsAvailable(Document document) {
    if (document.head == null) {
      document.children.insert(0, Element.html('<head></head>'));
    }
  }
}