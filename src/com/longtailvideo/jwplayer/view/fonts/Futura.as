import flash.text.Font;
import flash.text.TextFormat;

// UNICODE RANGE REFERENCE
/*
Default ranges
U+0020-U+0040, // Punctuation, Numbers
U+0041-U+005A, // Upper-Case A-Z
U+005B-U+0060, // Punctuation and Symbols
U+0061-U+007A, // Lower-Case a-z
U+007B-U+007E, // Punctuation and Symbols

Extended ranges (if multi-lingual required)
U+0080-U+00FF, // Latin I
U+0100-U+017F, // Latin Extended A
U+0400-U+04FF, // Cyrillic
U+0370-U+03FF, // Greek
U+1E00-U+1EFF, // Latin Extended Additional
U+0030-U+003A, // Numbers and :
*/

[Embed(
	source = 'futuram.ttf', 
	fontName = 'FUTURA',
	fontWeight = 'regular', 
	advancedAntiAliasing = 'true',
	unicodeRange = 'U+0020-U+005A,U+005B-U+007A,U+007B-U+007E',
	mimeType = 'application/x-font', embedAsCFF="false"
)]
public static const FUTURA :Class;

public static const DEFAULT_FONT :String        = "FUTURA";
public static const DEFAULT_TEXT_COLOUR :int = 0xCCCCCC;
public static const DEFAULT_TEXT_SIZE :int = 12;
public static const FUTURA_TEXT_FORMAT :TextFormat = new
TextFormat(DEFAULT_FONT, DEFAULT_TEXT_SIZE, DEFAULT_TEXT_COLOUR, null, null, null, null, null, "right");

public static const FUTURA_TEXT_FORMAT_LEFT :TextFormat = new
TextFormat(DEFAULT_FONT, DEFAULT_TEXT_SIZE, DEFAULT_TEXT_COLOUR, null, null, null, null, null, "left");

public static const FUTURA_TEXT_FORMAT_16 :TextFormat = new
TextFormat(DEFAULT_FONT, 16, DEFAULT_TEXT_COLOUR, null, null, null, null, null, "left");
