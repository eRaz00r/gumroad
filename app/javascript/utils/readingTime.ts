/**
 * Reading time calculation utilities for estimating how long it takes to read content.
 * Based on average reading speed and word count analysis.
 */

/**
 * Average reading speed in words per minute for typical readers.
 */
const WORDS_PER_MINUTE = 200;

/**
 * Minimum word count threshold below which reading time is not displayed.
 * Content shorter than this is considered too brief to warrant a reading time estimate.
 */
const MIN_WORD_COUNT = 50;

/**
 * Calculates the estimated reading time for a given text content.
 * Strips HTML tags, normalizes whitespace, and counts words to estimate reading duration.
 *
 * @param text - The text content to analyze (may contain HTML)
 * @returns Reading time in minutes, or 0 if content is too short or empty
 *
 * @example
 * ```typescript
 * calculateReadingTime("<p>This is a long article...</p>"); // Returns estimated minutes
 * calculateReadingTime("Short text"); // Returns 0 (below minimum word count)
 * ```
 */
export const calculateReadingTime = (text: string): number => {
  if (!text || text.trim().length === 0) return 0;

  const plainText = text.replace(/<[^>]*>/g, '').replace(/\s+/g, ' ').trim();
  const wordCount = plainText.split(/\s+/).filter(word => word.length > 0).length;

  // Return 0 for very short content (less than 50 words)
  if (wordCount < MIN_WORD_COUNT) return 0;

  const minutes = Math.ceil(wordCount / WORDS_PER_MINUTE);
  return Math.max(1, minutes);
};

/**
 * Formats reading time as a human-readable string.
 *
 * @param minutes - Reading time in minutes
 * @returns Formatted string like "5 min read", or empty string if 0 minutes
 *
 * @example
 * ```typescript
 * formatReadingTime(5); // "5 min read"
 * formatReadingTime(1); // "1 min read"
 * formatReadingTime(0); // ""
 * ```
 */
export const formatReadingTime = (minutes: number): string => {
  if (minutes === 0) return '';
  return `${minutes} min read`;
};

/**
 * Calculates reading time from a rich text editor instance.
 * Safely extracts plain text content from the editor and calculates reading time.
 *
 * @param editor - Editor instance with a getText() method (e.g., Quill, Draft.js)
 * @returns Reading time in minutes, or 0 if editor is invalid or content is too short
 *
 * @example
 * ```typescript
 * const editor = new QuillEditor();
 * calculateReadingTimeFromEditor(editor); // Returns estimated minutes based on editor content
 * ```
 */
export const calculateReadingTimeFromEditor = (editor: any): number => {
  if (!editor) return 0;

  try {
    const textContent = editor.getText();
    if (!textContent || textContent.trim().length === 0) return 0;
    return calculateReadingTime(textContent);
  } catch (error) {
    console.warn('Failed to get text from editor:', error);
    return 0;
  }
};
