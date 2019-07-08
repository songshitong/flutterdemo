import 'dart:core';

/**
 * Inner model class housing metadata for each frame.
 *
 * @see <a href="https://www.w3.org/Graphics/GIF/spec-gif89a.txt">GIF 89a Specification</a>
 */
class GifFrame {
  /**
   * GIF Disposal Method meaning take no action.
   * <p><b>GIF89a</b>: <i>No disposal specified.
   * The decoder is not required to take any action.</i></p>
   */
  static final DISPOSAL_UNSPECIFIED = 0;
  /**
   * GIF Disposal Method meaning leave canvas from previous frame.
   * <p><b>GIF89a</b>: <i>Do not dispose.
   * The graphic is to be left in place.</i></p>
   */
  static final DISPOSAL_NONE = 1;
  /**
   * GIF Disposal Method meaning clear canvas to background color.
   * <p><b>GIF89a</b>: <i>Restore to background color.
   * The area used by the graphic must be restored to the background color.</i></p>
   */
  static final DISPOSAL_BACKGROUND = 2;
  /**
   * GIF Disposal Method meaning clear canvas to frame before last.
   * <p><b>GIF89a</b>: <i>Restore to previous.
   * The decoder is required to restore the area overwritten by the graphic
   * with what was there prior to rendering the graphic.</i></p>
   */
  static final DISPOSAL_PREVIOUS = 3;

  /**
   * <p><b>GIF89a</b>:
   * <i>Indicates the way in which the graphic is to be treated after being displayed.</i></p>
   * Disposal methods 0-3 are defined, 4-7 are reserved for future use.
   *
   * @see #DISPOSAL_UNSPECIFIED
   * @see #DISPOSAL_NONE
   * @see #DISPOSAL_BACKGROUND
   * @see #DISPOSAL_PREVIOUS
   */

  int ix, iy, iw, ih;
/**
 * Control Flag.
 */
  bool interlace;
/**
 * Control Flag.
 */
  bool transparency;
/**
 * Disposal Method.
 */
  int dispose;
/**
 * Transparency Index.
 */
  int transIndex;
/**
 * Delay, in milliseconds, to next frame.
 */
  int delay;
/**
 * Index in the raw buffer where we need to start reading to decode.
 */
  int bufferFrameStart;
/**
 * Local Color Table.
 */
  List<int> lct;

  List<int> pixels;

  void resetFrame() {
    ix = null;
    iy = null;
    iw = null;
    ih = null;
    interlace = null;
    transparency = null;
    dispose = null;
    transIndex = null;
    delay = null;
    bufferFrameStart = null;
    lct = null;
  }
}
