/// Strips HTML tags from a string and returns clean plain text.
///
/// TVMaze returns show and episode summaries as raw HTML (e.g. `<p>`, `<b>`).
/// This utility removes those tags while collapsing extra whitespace.
String stripHtml(String? html) {
  if (html == null || html.isEmpty) return '';
  // Replace block-level tags with a space so paragraphs don't run together.
  final withSpaces = html
      .replaceAll(RegExp(r'<br\s*/?>',    caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</p>',          caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</li>',         caseSensitive: false), '\n');
  // Remove remaining tags.
  final stripped = withSpaces.replaceAll(RegExp(r'<[^>]*>'), '');
  // Normalise whitespace.
  return stripped.trim().replaceAll(RegExp(r' {2,}'), ' ');
}
