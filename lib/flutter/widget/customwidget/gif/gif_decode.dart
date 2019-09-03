import 'dart:async';
import 'dart:math' as Math;

import 'gif_frame.dart';

/*
https://www.w3.org/Graphics/GIF/spec-gif89a.txt
*/
class CustomDecodeGif {
  static const int MASK_INT_LOWEST_BYTE = 0x000000FF;

  /**
   * Mask (bit 7) to extract Local Color Table Flag of the current image.
   * <p><b>GIF89a</b>: <i>Indicates the presence of a Local Color Table
   * immediately following this Image Descriptor.</i></p>
   */
  static const int DESCRIPTOR_MASK_LCT_FLAG = 0x80;
  /**
   * Mask (bit 6) to extract Interlace Flag of the current image.
   * <p><b>GIF89a</b>: <i>Indicates if the image is interlaced.
   * An image is interlaced in a four-pass interlace pattern.</i></p>
   * Possible values are:<ul>
   * <li>0 - Image is not interlaced.</li>
   * <li>1 - Image is interlaced.</li>
   * </ul>
   */
  static const int DESCRIPTOR_MASK_INTERLACE_FLAG = 0x40;
  /**
   * Mask (bits 2-0) to extract Size of the Local Color Table of the current image.
   * <p><b>GIF89a</b>: <i>If the Local Color Table Flag is set to 1, the value in this
   * field is used to calculate the number of bytes contained in the Local Color Table.
   * To determine that actual size of the color table, raise 2 to [the value of the field + 1].
   * This value should be 0 if there is no Local Color Table specified.</i></p>
   */
  static const int DESCRIPTOR_MASK_LCT_SIZE = 0x7;
  List<int> bytes;
  List<GifFrame> frames = new List<GifFrame>();
  int index;
  int width;
  int height;
  bool gctFlag;
  int gctSize;
  int bgIndex;
  int pixelAspect;
  int bgColor;
  GifFrame currentFrame;
  int frameCount = 0;
  List<int> gct; //全局颜色列表
  int blockSize = 0; //扩展块大小
  List<int> block = new List(256); // current data block

  static const int MaxStackSize = 4096;
  // max decoder pixel stack size
  // LZW decoder working arrays
  List<int> prefix;
  List<int> suffix;
  List<int> pixelStack;
  List<int> pixels;

  int loopCount = 1; // iterations; 0 = repeat forever

  CustomDecodeGif(this.bytes) {
    checkSuffix();
  }

  List<int> decodeFirstFrame() {
    readLSD();
    readContents();
    //bytes是滚定长度的list
    return bytes.sublist(0, index);
  }

  void checkSuffix() {
    //前6位是GIF格式标识
    var headType = String.fromCharCodes(bytes, 0, 6);
    print("headType $headType");
    if (!headType.toUpperCase().startsWith("GIF")) {
      print("当前图片格式不是GIF");
    }
  }

  void readLSD() {
    index = 5;
    //2位代表宽，高
    width = readShort();
    print("width $width");
    height = readShort();
    print("height $height");

//     * 解析全局颜色列表(Global Color Table)的配置信息
//     * 配置信息占一个字节，具体各Bit存放的数据如下
//     *    7   6 5 4   3   2 1 0	 BIT
//     *  | m |   cr  | s | pixel |
    int packed = read();
    print("packed $packed");
    gctFlag = (packed & 0x80) != 0; //判断是否有全局颜色列表（m,0x80在计算机内部表示为1000 0000）
    print("gctFlag $gctFlag");

    gctSize = 2 << (packed & 7); //读取全局颜色列表大小（pixel）
    print("gctSize $gctSize");

    //读取背景颜色索引和像素宽高比(Pixel Aspect Radio)
    bgIndex = read();
    print("bgIndex $bgIndex");

    pixelAspect = read();
    print("pixelAspect $pixelAspect");

    if (gctFlag) {
      gct = readColorTable(gctSize);
      bgColor = gct[bgIndex]; //根据索引在全局颜色列表拿到背景颜色
      print("bgColor $bgColor");
    }
  }

  int readShort() {
    final a = read();
    final b = read() << 8;
    return a | b;
  }

  //读取下一个
  int read() {
    index++;
    return bytes[index];
  }

  List<int> readColorTable(int ncolors) {
    int nbytes = 3 * ncolors; //一个颜色占3个字节（r g b 各占1字节），因此占用空间为 颜色数量*3 字节
    List<int> tab = null;
    List<int> c = new List(nbytes);
    index++;
    for (int i1 = index; i1 < index + nbytes; i1++) {
      c[i1 - index] = bytes[i1];
    }
    //当前index
    index = index + nbytes - 1;
    //开始解析颜色列表
    tab = new List(256); //设置最大尺寸避免边界检查
    int i = 0;
    int j = 0;
    while (i < ncolors) {
      int r = (c[j++]) & 0xff;
      int g = (c[j++]) & 0xff;
      int b = (c[j++]) & 0xff;
      tab[i++] = 0xff000000 | (r << 16) | (g << 8) | b;
    }
    return tab;
  }

  /**
   * Reads next frame image.
   * 按顺序读取图像块数据：
   * 图象标识符(Image Descriptor)
   * 局部颜色列表(Local Color Table)（有的话）
   * 基于颜色列表的图象数据(Table-Based Image Data)
   */
  void readImage() {
    // (sub)image position & size.
    currentFrame.ix = readShort();
    currentFrame.iy = readShort();
    currentFrame.iw = readShort();
    currentFrame.ih = readShort();
    print("current ix ${currentFrame.ix} iy ${currentFrame.iy} iw ${currentFrame.iw} ih ${currentFrame.ih}");

    /*
     * Image Descriptor packed field:
     *     7 6 5 4 3 2 1 0
     *    +---------------+
     * 9  | | | |   |     |
     *
     * Local Color Table Flag     1 Bit
     * Interlace Flag             1 Bit
     * Sort Flag                  1 Bit
     * Reserved                   2 Bits
     * Size of Local Color Table  3 Bits
     */
    int packed = read();
    bool lctFlag = (packed & DESCRIPTOR_MASK_LCT_FLAG) != 0;
    int lctSize = 2 << (packed & 7);
    currentFrame.interlace = (packed & DESCRIPTOR_MASK_INTERLACE_FLAG) != 0;
    print("currentFrame.interlace ${currentFrame.interlace}");

    var act = null;
    if (lctFlag) {
      act = readColorTable(lctSize); //若有局部颜色列表，则图象数据是基于局部颜色列表的
    } else {
      // No local color table.
      act = gct; //否则都以全局颜色列表为准
      if (bgIndex == currentFrame.transIndex) {
        bgColor = 0;
      }
    }
    currentFrame.lct = act;
    int save = 0;
    if (currentFrame.transparency) {
      save = act[currentFrame.transIndex]; //保存透明色索引位置原来的颜色
      act[currentFrame.transIndex] = 0; //根据索引位置设置透明颜色
    }
    if (act == null) {
      print("readImage 没有可用的颜色列表");
      return;
    }
    //第index++ 正式开始
    currentFrame.bufferFrameStart = index;

    /**
     * 开始解码图像数据
     */
    currentFrame.pixels = decodeImageData();
    skip();

    frameCount++;
    // Add image to frame.
    frames.add(currentFrame);
    print(" currentFrame.lct ${currentFrame.lct} ");
    if (currentFrame.transparency) {
      act[currentFrame.transIndex] = save; //重置回原来的颜色
    }
    currentFrame.resetFrame();
  }

//  解码图像数据
  List<int> decodeImageData() {
    int NullCode = -1;
    int npix = currentFrame.iw * currentFrame.ih;
    int available,
        clear,
        code_mask,
        code_size,
        end_of_information,
        in_code,
        old_code,
        bits,
        code,
        count,
        i,
        datum,
        data_size,
        first,
        top,
        bi,
        pi;

    if ((pixels == null) || (pixels.length < npix)) {
      pixels = List(npix); // allocate new pixel array
    }
    if (prefix == null) {
      prefix = List(MaxStackSize);
    }
    if (suffix == null) {
      suffix = List(MaxStackSize);
    }
    if (pixelStack == null) {
      pixelStack = List(MaxStackSize + 1);
    }
    // Initialize GIF data stream decoder.
    data_size = read();
    clear = 1 << data_size;
    end_of_information = clear + 1;
    available = clear + 2;
    old_code = NullCode;
    code_size = data_size + 1;
    code_mask = (1 << code_size) - 1;
    for (code = 0; code < clear; code++) {
      prefix[code] = 0;
      suffix[code] = code;
    }

    // Decode GIF pixel stream.
    datum = bits = count = first = top = pi = bi = 0;
    for (i = 0; i < npix;) {
      if (top == 0) {
        if (bits < code_size) {
          // Load bytes until there are enough bits for a code.
          if (count == 0) {
            // Read a new data block.
            count = readBlock();
            if (count <= 0) {
              break;
            }
            bi = 0;
          }
          datum += ((block[bi]) & 0xff) << bits;
          bits += 8;
          bi++;
          count--;
          continue;
        }
        // Get the next code.
        code = datum & code_mask;
        datum >>= code_size;
        bits -= code_size;

        // Interpret the code
        if ((code > available) || (code == end_of_information)) {
          break;
        }
        if (code == clear) {
          // Reset decoder.
          code_size = data_size + 1;
          code_mask = (1 << code_size) - 1;
          available = clear + 2;
          old_code = NullCode;
          continue;
        }
        if (old_code == NullCode) {
          pixelStack[top++] = suffix[code];
          old_code = code;
          first = code;
          continue;
        }
        in_code = code;
        if (code == available) {
          pixelStack[top++] = first;
          code = old_code;
        }
        while (code > clear) {
          pixelStack[top++] = suffix[code];
          code = prefix[code];
        }
        first = (suffix[code]) & 0xff;
        // Add a new string to the string table,
        if (available >= MaxStackSize) {
          break;
        }
        pixelStack[top++] = first;
        prefix[available] = old_code;
        suffix[available] = first;
        available++;
        if (((available & code_mask) == 0) && (available < MaxStackSize)) {
          code_size++;
          code_mask += available;
        }
        old_code = in_code;
      }

      // Pop a pixel off the pixel stack.
      top--;
      pixels[pi++] = pixelStack[top];
      i++;
    }
    for (i = pi; i < npix; i++) {
      pixels[i] = 0; // clear missing pixels
    }
    print("decodeImageData pixels $pixels ");
    return pixels;
  }

  /**
   * Skips variable length blocks up to and including next zero length block.
   */
  void skip() {
    do {
      readBlock();
    } while (blockSize > 0);
  }

  /**
   * 读取扩展块(应用程序扩展块)
   * @return
   */
  int readBlock() {
    blockSize = read();
//    print("blockSize $blockSize");
    int n = 0;
    if (blockSize > 0) {
      int count = 0;
      while (n < blockSize) {
        count = readArray(block, n, blockSize - n);
        if (count == -1) {
          break;
        }
        n += count;
      }

      if (n < blockSize) {
        print("readBlock err =====");
      }
    }
    return n;
  }

  int readArray(List<int> b, int off, int len) {
    if (b == null) {
      return 0;
    } else if (off < 0 || len < 0 || len > b.length - off) {
      return 0;
    } else if (len == 0) {
      return 0;
    }

    int c = read();
    if (c == -1) {
      return -1;
    }
    b[off] = c;

    int i = 1;

    for (; i < len; i++) {
      c = read();
      if (c == -1) {
        break;
      }
      b[off + i] = c;
    }

    return i;
  }

  int getLoopCount() {
    return loopCount;
  }

  void readNetscapeExt() {
    do {
      readBlock();
      if (block[0] == 1) {
        // loop count sub-block
        int b1 = (block[1]) & 0xff;
        int b2 = (block[2]) & 0xff;
        loopCount = (b2 << 8) | b1;
      }
    } while ((blockSize > 0));
  }

  /**
   * 读取图形控制扩展块
   */
  void readGraphicControlExt() {
    read(); //按读取顺序，此处为块大小

    int packed = read(); //读取处置方法、用户输入标志等
    currentFrame.dispose = (packed & 0x1c) >> 2; //从packed中解析出处置方法(Disposal Method)
    if (currentFrame.dispose == 0) {
      currentFrame.dispose = 1; //elect to keep old image if discretionary
    }
    currentFrame.transparency = (packed & 1) != 0; //从packed中解析出透明色标志

    currentFrame.delay = readShort() * 10; //读取延迟时间(毫秒)
    currentFrame.transIndex = read(); //读取透明色索引
    read(); //按读取顺序，此处为标识块终结(Block Terminator)
  }

  ///while (!done && frames.length != 1) 只读取第一帧
  void readContents() {
    bool done = false;
    while (!done && frames.length != 1) {
      int code = read();
      switch (code) {
        //图象标识符(Image Descriptor)开始
        case 0x2C:
          print("readContents 0x2C  ==== ");
          if (currentFrame == null) {
            currentFrame = new GifFrame();
          }
          readImage();
          break;
        //扩展块开始
        case 0x21: //扩展块标识，固定值0x21
          print("readContents 0x21  ==== ");
          code = read();
          switch (code) {
            case 0xf9: //图形控制扩展块标识(Graphic Control Label)，固定值0xf9
              print("readContents 0xf9  ==== ");
              currentFrame = new GifFrame();
              readGraphicControlExt();
              break;
            case 0xff: //应用程序扩展块标识(Application Extension Label)，固定值0xFF
              print("readContents 0xff  ==== ");
              readBlock();
              String app = "";
              for (int i = 0; i < 11; i++) {
                app += String.fromCharCode(block[i]);
              }
              if (app == "NETSCAPE2.0") {
                readNetscapeExt();
              } else {
                skip(); // don't care
              }
              break;
            default: //其他扩展都选择跳过
              skip();
          }
          break;

        case 0x3b: //标识GIF文件结束，固定值0x3B
          print("readContents 0x3b  ==== ");

          done = true;
          break;

        case 0x00: //可能会出现的坏字节，可根据需要在此处编写坏字节分析等相关内容
          print("readContents 0x00  ==== ");

          break;
        default:
          print("readContents status err");
      }
    }
  }
}
