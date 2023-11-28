# Test Task

## Objective: Develop an iOS application (minimum iOS version — 11.0):
- The user enters the URL of a text file, a filter for selecting lines, and starts the download (for example, by pressing a button).
- The application loads the file, selects lines that meet the filter criteria, and displays them in a list.

## Line Selection Principle:
Assume that the text file is an ANSI text file (no need to rely on UTF-8).
Line selection is based on the conditions of a simple regexp (at least the * and ? operators):
- The '*' symbol represents a sequence of any characters of unlimited length;
- The '?' symbol represents any single character;
- Masks such as *Some*, *Some, Some*, *****Some*** should work correctly — there are no restrictions on the position of * in the mask.

## The search result should be lines that satisfy the mask:
For example:
1. The mask *abc* selects all lines containing abc, starting and ending with any sequence of characters.
2. The mask abc* selects all lines starting with abc and ending with any sequence of characters.
3. The mask abc? selects all lines starting with abc and ending with any additional character.
4. The mask abc selects all lines that are equal to this mask.

## Implementation Requirements:
1. Use Objective C or Swift - author's choice.
2. Text processing (and displaying results) should be done as each new portion of data is loaded. It is not recommended to download the entire file and then process it.
3. The size of the original text file (and possibly the results) can be hundreds of megabytes.
4. Memory usage should be minimal (within reasonable limits).
5. Parsing results should be written to a results.log file in the application directory.
6. The result should be presented as a list (UITableView \ UICollectionView).
7. The code must be absolutely "bulletproof" and protected from errors.

## Formatting Requirements:
1. The code should be as simple as possible;
2. The code should be clean, beautiful, and understandable;
3. The result should be a ready-to-use application project in a ZIP archive.
