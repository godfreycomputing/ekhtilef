import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';

import '../../../core/common/dimens.dart';
import '../bloc/image_editor_step_bloc.dart';
import '../widget/all_emojies.dart';
import '../widget/bottombar_container.dart';
import '../widget/colors_picker.dart';
import '../widget/image_editor_first_step_inital_add_image_widget.dart';
import '../widget/image_editor_utils.dart';
import '../widget/view_save_image.dart';

SignatureController _controller =
    SignatureController(penStrokeWidth: 5, penColor: Colors.green);

class TShirtEditor extends StatefulWidget {
  final String path;

  const TShirtEditor({Key? key,required this.path}) : super(key: key);
  @override
  _TShirtEditorState createState() => _TShirtEditorState();
}

class _TShirtEditorState extends State<TShirtEditor> {
  /// Controls whether this widget has keyboard focus.
  final FocusNode textFocusNode = FocusNode();
  ImageEditorUtils? utils;
  String? _textOrEmojiValue;
  ValueNotifier<Matrix4>? _valueNotifierForBorderBoxColor;
  ValueNotifier<Color>? _valueNotifierToScaleAndRotateWidget;
  ValueNotifier<Color>? _valueNotifierToSetTextColor;
  ValueNotifier<bool>? _valueNotifierToSetTextBackgroundFilled;
  //ValueNotifier<File>? _
  final ImageEditorStepBloc _imageEditorStepBloc = ImageEditorStepBloc();
  double _editorBoxWidth = 300;
  double _editorBoxHeight = 300;
  GlobalKey _containerKey = GlobalKey();
  GlobalKey _cropImagekey = GlobalKey();

  // create some values
  Color pickerColor = const Color(0xff443a49);

  final int _emojiFontSize = 256;

  Size _getSizes() {
    final renderBoxRed =
        _cropImagekey.currentContext!.findRenderObject() as RenderBox;
    final sizeRed = renderBoxRed.size;
    print("SIZE of Box: $sizeRed");
    return sizeRed;
  }

  Offset _getPositions() {
    final renderBoxRed =
        _cropImagekey.currentContext!.findRenderObject() as RenderBox;
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    print("POSITION of Box: $positionRed ");
    return positionRed;
  }

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    var points = _controller.points;
    _controller =
        SignatureController(penStrokeWidth: 5, penColor: color, points: points);
  }

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void dispose() {
    _imageEditorStepBloc.close();
    textFocusNode.dispose();
    _valueNotifierForBorderBoxColor!.dispose();
    _valueNotifierToScaleAndRotateWidget!.dispose();
    _valueNotifierToSetTextBackgroundFilled!.dispose();
    _valueNotifierToSetTextColor!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    utils = ImageEditorUtils(
        context: context, imageEditorStepBloc: _imageEditorStepBloc);
    _textOrEmojiValue = '';
    _valueNotifierForBorderBoxColor = ValueNotifier(Matrix4.identity());
    _valueNotifierToScaleAndRotateWidget = ValueNotifier(Colors.black);
    _valueNotifierToSetTextBackgroundFilled = ValueNotifier(false);
    _valueNotifierToSetTextColor = ValueNotifier(Colors.black);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _editorBoxHeight = MediaQuery.of(context).size.height / 2.3;
    _editorBoxWidth = MediaQuery.of(context).size.width / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;
    ScreenUtil.init(BoxConstraints(maxHeight: s.height, maxWidth: s.width, minHeight: 0, minWidth: 0));
    return   Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Center(
            child: Screenshot(
              controller: screenshotController,
              key: _containerKey,
              child: BlocBuilder(
                  bloc: _imageEditorStepBloc,
                  buildWhen: (c, p) => c != p,
                  builder: (context, state) { 
                    
                    // if (state is ImageEditorFirstStepInitialAddImageState) {
                    //   return ImageEditorFirstStepInitialAddImageWidget(
                    //     imageEditorStepBloc: _imageEditorStepBloc,
                    //   );
                    // }
                    if (state is InsertImageState) {
                      return SizedBox(
                        key: _containerKey,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: <Widget>[
                            InteractiveViewer(
                              child: Image.file(
                                state.baseImage,
                                isAntiAlias: true,
                                height: state.height.toDouble(),
                                width: state.width.toDouble(),
                                fit: BoxFit.contain,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      key: _cropImagekey,
                                      width: _editorBoxWidth,
                                      height: _editorBoxHeight,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 0.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is StickerImageState) {
                      return SizedBox(
                        key: _containerKey,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: <Widget>[
                            state.baseImage != null
                                ? InteractiveViewer(
                                    child: Image.file(
                                      state.baseImage,
                                      isAntiAlias: true,
                                      height: state.height.toDouble(),
                                      width: state.width.toDouble(),
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Container(),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                key: _cropImagekey,
                                width: _editorBoxWidth,
                                height: _editorBoxHeight,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: _editorBoxWidth,
                                        height: _editorBoxHeight,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                _valueNotifierToScaleAndRotateWidget!
                                                    .value,
                                            width: 0.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    MatrixGestureDetector(
                                      onMatrixUpdate: (m, tm, sm, rm) {
                                        _valueNotifierForBorderBoxColor!.value =
                                            m;
                                      },
                                      child: AnimatedBuilder(
                                          animation:
                                              _valueNotifierForBorderBoxColor!,
                                          builder: (ctx, child) {
                                            return Transform(
                                              transform:
                                                  _valueNotifierForBorderBoxColor!
                                                      .value,
                                              child: Image.file(
                                                state.layerImage,
                                                isAntiAlias: true,
                                                width: _editorBoxWidth,
                                                height: _editorBoxHeight,
                                                fit: BoxFit.contain,
                                              ),
                                            );
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is PaintImageState) {
                      return SizedBox(
                        key: _containerKey,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: <Widget>[
                            state.baseImage != null
                                ? InteractiveViewer(
                                    child: Image.file(
                                      state.baseImage,
                                      isAntiAlias: true,
                                      height: state.height.toDouble(),
                                      width: state.width.toDouble(),
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Container(),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: _editorBoxWidth,
                                height: _editorBoxHeight,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: _editorBoxWidth,
                                        height: _editorBoxHeight,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                _valueNotifierToScaleAndRotateWidget!
                                                    .value,
                                            width: 0.2,
                                          ),
                                        ),
                                        child: Painter(
                                          editorBoxHeight: _editorBoxHeight,
                                          editorBoxWidth: _editorBoxWidth,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is TextImageState) {
                      if (MediaQuery.of(context).viewInsets.bottom == 0) {
                        textFocusNode.unfocus();
                      }
                      return SizedBox(
                        key: _containerKey,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: <Widget>[
                            state.baseImage != null
                                ? InteractiveViewer(
                                    child: Image.file(
                                      state.baseImage,
                                      isAntiAlias: true,
                                      height: state.height.toDouble(),
                                      width: state.width.toDouble(),
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Container(),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: _editorBoxWidth,
                                height: _editorBoxHeight,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: _editorBoxWidth,
                                        height: _editorBoxHeight,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                _valueNotifierToScaleAndRotateWidget!
                                                    .value,
                                            width: 0.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    MatrixGestureDetector(
                                      onMatrixUpdate: (m, tm, sm, rm) {
                                        _valueNotifierForBorderBoxColor!.value =
                                            m;
                                      },
                                      child: AnimatedBuilder(
                                          animation:
                                              _valueNotifierForBorderBoxColor!,
                                          builder: (ctx, child) {
                                            return Transform(
                                              transform:
                                                  _valueNotifierForBorderBoxColor!
                                                      .value,
                                              child: SizedBox(
                                                  width: _editorBoxWidth,
                                                  height: _editorBoxHeight,
                                                  child: TextFormField(
                                                    focusNode: textFocusNode,
                                                    cursorColor:
                                                        _valueNotifierToSetTextColor!
                                                            .value,
                                                    cursorWidth: 1,
                                                    maxLines: 10,
                                                    autofocus: true,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    textInputAction:
                                                        TextInputAction.newline,
                                                    decoration: const InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                    ),
                                                    style: TextStyle(
                                                        color:
                                                            _valueNotifierToSetTextColor!
                                                                .value,
                                                        decorationThickness:
                                                            0.001,
                                                        fontSize: ScreenUtil()
                                                            .setSp(Dimens
                                                                .font_sp28),
                                                        background: Paint()
                                                          ..color = _valueNotifierToSetTextBackgroundFilled!
                                                                      .value ==
                                                                  true
                                                              ? Colors.white
                                                              : Colors
                                                                  .transparent),
                                                  )),
                                            );
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is EmojiImageState) {
                      return SizedBox(
                        key: _containerKey,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: <Widget>[
                            state.baseImage != null
                                ? InteractiveViewer(
                                    child: Image.file(
                                      state.baseImage,
                                      isAntiAlias: true,
                                      height: state.height.toDouble(),
                                      width: state.width.toDouble(),
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Container(),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: _editorBoxWidth,
                                height: _editorBoxHeight,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: _editorBoxWidth,
                                        height: _editorBoxHeight,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                _valueNotifierToScaleAndRotateWidget!
                                                    .value,
                                            width: 0.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    MatrixGestureDetector(
                                      onMatrixUpdate: (m, tm, sm, rm) {
                                        _valueNotifierForBorderBoxColor!.value =
                                            m;
                                      },
                                      child: AnimatedBuilder(
                                          animation:
                                              _valueNotifierForBorderBoxColor!,
                                          builder: (ctx, child) {
                                            return Transform(
                                              transform:
                                                  _valueNotifierForBorderBoxColor!
                                                      .value,
                                              child: SizedBox(
                                                width: _editorBoxWidth,
                                                height: _editorBoxHeight,
                                                child: Text(
                                                    "$_textOrEmojiValue",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(
                                                              _emojiFontSize),
                                                    )),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ImageEditorFirstStepInitialAddImageWidget(path: widget.path,
                        imageEditorStepBloc: _imageEditorStepBloc,
                      );
                    }
                  }),
            ),
          ),
          bottomNavigationBar: BlocBuilder(
              bloc: _imageEditorStepBloc,
              buildWhen: (c, p) => c != p,
              builder: (context, state) {
                print(state);
                if (state is ImageEditorFirstStepInitialAddImageState) {
                  return Container(
                    height: 0,
                  );
                } else if (state is InsertImageState) {
                  return Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(blurRadius: 4)]),
                    height: kToolbarHeight,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        BottomBarContainer(
                          colors: Colors.white,
                          icons: FontAwesomeIcons.brush,
                          onTap: () async {
                            print('brush');
                            // raise the [showDialog] widget
                            await showDialog(
                                builder: (context) => AlertDialog(
                                      title: const Text('Pick a color!'),
                                      content: SingleChildScrollView(
                                        child: ColorPicker(
                                          pickerColor: pickerColor,
                                          onColorChanged: changeColor,
                                          showLabel: true,
                                          pickerAreaHeightPercent: 0.8,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: const Text('Use it'),
                                          onPressed: () {
                                            setState(() =>
                                                _valueNotifierToSetTextColor!
                                                    .value = pickerColor);
                                            Navigator.of(context).pop();
                                            _imageEditorStepBloc
                                                .add(const AddPainterImageEvent());
                                          },
                                        ),
                                      ],
                                    ),
                                context: context);
                          },
                        ),
                        BottomBarContainer(
                          colors: Colors.white,
                          icons: Icons.text_fields,
                          onTap: () {
                            print('mrgl');
                            _imageEditorStepBloc.add(const AddTextImageEvent());
                          },
                        ),
                        BottomBarContainer(
                          colors: Colors.white,
                          icons: FontAwesomeIcons.smile,
                          onTap: () {
                            print('smile');
                            _imageEditorStepBloc.add(const AddEmojiImageEvent());
                            var getEmojis = showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Emojies();
                                });
                            getEmojis.then((value) {
                              if (value != null) {
                                setState(() {
                                  _textOrEmojiValue = value;
                                });
                              }
                            });
                          },
                        ),
                        BottomBarContainer(
                          colors: Colors.white,
                          icons: Icons.camera,
                          onTap: () {
                            utils!.openPhotoBottomSheetsToAddBaseImageOrSticker(
                              (image, height, width) => AddStickerLayerEvent(
                                baseImage: image,
                                height: height,
                                width: width,
                              ),
                              isSticker: true,
                            );
                          },
                        ),
                        BottomBarContainer(
                          colors: Colors.white,
                          icons: Icons.arrow_back_ios,
                          onTap: () {
                            _imageEditorStepBloc.add(const UndoChangeEvent());
                          },
                        ),
                        BottomBarContainer(
                          colors: Colors.white,
                          icons: Icons.save_alt,
                          onTap: () async {
                            await Navigator.of(context).push(CupertinoPageRoute(
                                builder: (BuildContext context) => ImageView(
                                      key: UniqueKey(),
                                      file: state.baseImage,
                                      offsetOfBoxImage: _getPositions(),
                                      sizeOfBoxImage: _getSizes(),
                                      imageEditorStepBloc: _imageEditorStepBloc,
                                    )));
                          },
                        ),
                      ],
                    ),
                  );
                } else if (state is TextImageState) {
                  return Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(blurRadius: 4)]),
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        BottomBarContainer(
                          colors: Colors.white,
                          icons: Icons.close,
                          onTap: () {
                            _controller.clear();
                            _textOrEmojiValue = '';
                            _valueNotifierForBorderBoxColor =
                                ValueNotifier(Matrix4.identity());
                            _imageEditorStepBloc.add(const ExitEditImageEvent());
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.title,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _valueNotifierToSetTextBackgroundFilled!.value =
                                  !_valueNotifierToSetTextBackgroundFilled!
                                      .value;
                            });
                          },
                        ),
                        BarColorPicker(
                            width: MediaQuery.of(context).size.width / 2.5,
                            thumbColor: Colors.white,
                            cornerRadius: 10,
                            pickMode: PickMode.Color,
                            colorListener: (int value) {
                              setState(() {
                                _valueNotifierToSetTextColor!.value =
                                    Color(value);
                              });
                            }),
                        BottomBarContainer(
                          colors: Colors.white,
                          icons: Icons.assignment_turned_in_sharp,
                          onTap: () async {
                            print('hani mawjoud');
                            setState(() {
                              _valueNotifierToScaleAndRotateWidget!.value =
                                  Colors.transparent;
                            });
                            await screenshotController
                                .capture(pixelRatio: 2)
                                .then((image) async {
                              final _imageFromPicker = File(File.fromRawPath(image!).path);
                              final decodedImage = await decodeImageFromList(
                                  _imageFromPicker.readAsBytesSync());
                              _imageEditorStepBloc.add(SaveEditImageEvent(
                                  baseImage: File.fromRawPath(image),
                                  height: decodedImage.height,
                                  width: decodedImage.width));
                              _controller.clear();
                              _textOrEmojiValue = "";
                              _valueNotifierForBorderBoxColor =
                                  ValueNotifier(Matrix4.identity());
                              _valueNotifierToScaleAndRotateWidget!.value =
                                  Colors.black;
                            }).onError((error, stackTrace) {print('$error «««««««««««« $stackTrace');});
                          },
                        ),
                      ],
                    ),
                  );
                } else if (state is EmojiImageState) {
                  return _saveOrExitEditImage(context);
                } else if (state is PaintImageState) {
                  return _saveOrExitEditImage(context);
                } else if (state is StickerImageState) {
                  return _saveOrExitEditImage(context);
                }
                return Container();
              })
    );
  }

  Container _saveOrExitEditImage(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white, boxShadow: [BoxShadow(blurRadius: 4)]),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BottomBarContainer(
                          colors: Colors.white,
            icons: Icons.close,
            onTap: () {
              _controller.clear();
              _textOrEmojiValue = "";
              _valueNotifierForBorderBoxColor =
                  ValueNotifier(Matrix4.identity());
              _imageEditorStepBloc.add(const ExitEditImageEvent());
            },
          ),
          BottomBarContainer(
                          colors: Colors.white,
            icons: Icons.assignment_turned_in_sharp,
            onTap: () {
              setState(() {
                _valueNotifierToScaleAndRotateWidget!.value = Colors.transparent;
              });
              screenshotController
                  .capture(pixelRatio: 1.5)
                  .then((image) async {
                final _imageFromPicker = File(File.fromRawPath(image!).path);
                final decodedImage = await decodeImageFromList(
                    _imageFromPicker.readAsBytesSync());
                _imageEditorStepBloc.add(SaveEditImageEvent(
                    baseImage: File.fromRawPath(image),
                    height: decodedImage.height,
                    width: decodedImage.width));
                _controller.clear();
                _textOrEmojiValue = "";
                _valueNotifierForBorderBoxColor =
                    ValueNotifier(Matrix4.identity());
                _valueNotifierToScaleAndRotateWidget!.value = Colors.black;
              }).onError((error, stackTrace) {print('$error «««««««««««« $stackTrace');});
            },
          ),
        ],
      ),
    );
  }
}

class Painter extends StatefulWidget {
  final double editorBoxHeight;
  final double editorBoxWidth;

  const Painter({
    Key? key,
    required this.editorBoxHeight,
    required this.editorBoxWidth,
  }) : super(key: key);
  @override
  _PainterState createState() => _PainterState();
}

class _PainterState extends State<Painter> {
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print("Value changed"));
  }

  @override
  Widget build(BuildContext context) {
    return Signature(
      controller: _controller,
      height: widget.editorBoxHeight,
      width: widget.editorBoxWidth,
      backgroundColor: Colors.transparent,
    );
  }
}
