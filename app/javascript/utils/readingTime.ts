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
const MIN_WORD_COUNT = 200;

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

  // Handle null, undefined, or non-string inputs
  if (!text || typeof text !== 'string' || text.trim().length === 0) return 0;

  try {
       const plainText = text.replace(/<[^>]*>/g, '').replace(/\s+/g, ' ').trim();
       const wordCount = plainText.split(/\s+/).filter(word => word.length > 0).length;

       // Return 0 for very short content (less than minimum word count)
       if (wordCount < MIN_WORD_COUNT) return 0;

       const minutes = Math.ceil(wordCount / WORDS_PER_MINUTE);
       return Math.max(1, minutes);
  } catch (error) {
    // Return 0 if any error occurs during processing
    console.warn('Error calculating reading time:', error);
    return 0;
  }
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
