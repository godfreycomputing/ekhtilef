// import 'dart:async';
// import 'dart:io';

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:gallery_saver/gallery_saver.dart';

// part 'image_editor_step_event.dart';

// part 'image_editor_step_state.dart';

// class ImageEditorStepBloc
//     extends Bloc<ImageEditorStepEvent, ImageEditorStepState> {
//   ImageEditorStepBloc()
//       : super(const ImageEditorFirstStepInitialAddImageState()) {
//     on<UndoChangeEvent>((event, emit) => _onUndoChanges());
//     on<AddImageEvent>((event, emit) => _onAddImageEvent(event));
//     on<SaveImageInGallery>((event, emit)=>_onSaveImageInGallery(event));
//     on<AddImageEvent>((event, emit)=>_onAddImageEvent(event));
//     on<ExitEditImageEvent>((event, emit)=>_onExitEditImageEvent());
//     on<SaveEditImageEvent>((event, emit)=>_onSaveEditImageEvent(event));
//     on<AddTextImageEvent>((event, emit)=>_onAddTextImageEvent());
//     on<AddEmojiImageEvent>((event, emit)=> _onAddEmojiImageEvent());
//     on<AddPainterImageEvent>((event, emit)=>_onAddPainterImageEvent());
//     on<AddStickerLayerEvent>((event, emit)=>_onAddStickerLayerEvent(event));
//   }
  
//   List<File> listOfEditingImage = <File>[];
//   final List<int> _height = <int>[];
//   final List<int> _width = <int>[];

//   Stream<void> _onUndoChanges() async* {
//     if (listOfEditingImage.length <= 1 ||
//         _height.length <= 1 ||
//         _width.length <= 1) {
//       return;
//     }
//     listOfEditingImage.removeLast();
//     _height.removeLast();
//     _width.removeLast();
//     yield InsertImageState(
//       baseImage: listOfEditingImage.last,
//       height: _height.last,
//       width: _width.last,
//     );
//   }

//   ///
//   void _onSaveImageInGallery(event) async {
//     await GallerySaver.saveImage(listOfEditingImage.last.path,
//         albumName: 'TShirt');

//     /// Save box ima
//     await GallerySaver.saveImage(event.boxImage.path, albumName: 'TShirt');
//   }

//   Stream<void> _onAddImageEvent(event) async* {
//     listOfEditingImage.add(event.baseImage);
//     _height.add(event.height);
//     _width.add(event.width);
//     yield InsertImageState(
//       baseImage: event.baseImage,
//       height: event.height,
//       width: event.width,
//     );
//   }

//   Stream<void> _onExitEditImageEvent() async* {
//     yield InsertImageState(
//       baseImage: listOfEditingImage.last,
//       height: _height.last,
//       width: _width.last,
//     );
//   }

//   Stream<void> _onSaveEditImageEvent(event) async* {
//     listOfEditingImage.add(event.baseImage);
//     _height.add(event.height);
//     _width.add(event.width);
//     yield InsertImageState(
//       baseImage: listOfEditingImage.last,
//       height: _height.last,
//       width: _width.last,
//     );
//   }

//   Stream<void> _onAddTextImageEvent() async* {
//     yield TextImageState(
//       baseImage: listOfEditingImage.last,
//       height: _height.last,
//       width: _width.last,
//     );
//   }
//     Stream<void> _onAddEmojiImageEvent() async* {
//       yield EmojiImageState(
//         baseImage: listOfEditingImage.last,
//         height: _height.last,
//         width: _width.last,
//       );
//     }

//     Stream<void> _onAddPainterImageEvent() async* {
//       yield PaintImageState(
//         baseImage: listOfEditingImage.last,
//         height: _height.last,
//         width: _width.last,
//       );
//     }

//     Stream<void> _onAddStickerLayerEvent(event) async* {
//       yield StickerImageState(
//         layerImage: event.baseImage,
//         baseImage: listOfEditingImage.last,
//         height: _height.last,
//         width: _width.last,
//       );
//     }
//   }

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gallery_saver/gallery_saver.dart';

part 'image_editor_step_event.dart';

part 'image_editor_step_state.dart';

class ImageEditorStepBloc
    extends Bloc<ImageEditorStepEvent, ImageEditorStepState> {
  ImageEditorStepBloc() : super(ImageEditorFirstStepInitialAddImageState());

  List<File> listOfEditingImage= <File>[];
  List<int> _height = <int>[];
  List<int> _width = <int>[];
  int counter = 1;
  @override
  Stream<ImageEditorStepState> mapEventToState(
    ImageEditorStepEvent event,
  ) async* {

    if(event is UndoChangeEvent){
      if(listOfEditingImage.length <= 1
          ||_height.length <= 1
          ||_width.length <= 1){
        return;
      }
      listOfEditingImage.removeLast();
      _height.removeLast();
      _width.removeLast();
      yield InsertImageState(
        baseImage: listOfEditingImage.last,
        height: _height.last,
        width: _width.last,
      );
    }
    else if(event is SaveImageInGallery){
      await GallerySaver.saveImage(
          listOfEditingImage.last.path,
          albumName: "TShirt"
      );
      /// Save box ima
      await GallerySaver.saveImage(
          event.boxImage.path,
          albumName: "TShirt"
      );
    }
    else if (event is AddImageEvent) {
      listOfEditingImage.add(event.baseImage);
      _height.add(event.height);
      _width.add(event.width);
      yield InsertImageState(
        baseImage: event.baseImage,
        height: event.height,
        width: event.width,
      );
    }
    else if (event is ExitEditImageEvent){
      yield InsertImageState(
        baseImage: listOfEditingImage.last,
        height: _height.last,
        width: _width.last,
      );
    }
    else if(event is SaveEditImageEvent){
      listOfEditingImage.add(event.baseImage);
      _height.add(event.height);
      _width.add(event.width);
      yield InsertImageState(
        baseImage: listOfEditingImage.last,
        height: _height.last,
        width: _width.last,
      );
    }
    else if(event is AddTextImageEvent){
      yield TextImageState(
        baseImage: listOfEditingImage.last,
        height: _height.last,
        width: _width.last,
      );
    }
    else if(event is AddEmojiImageEvent){
      yield EmojiImageState(
        baseImage: listOfEditingImage.last,
        height: _height.last,
        width: _width.last,
      );
    }
    else if(event is AddPainterImageEvent){
      yield PaintImageState(
        baseImage: listOfEditingImage.last,
        height: _height.last,
        width: _width.last,
      );
    }
    else if(event is AddStickerLayerEvent){
      yield StickerImageState(
        layerImage: event.baseImage,
        baseImage: listOfEditingImage.last,
        height: _height.last,
        width: _width.last,
      );
    }
  }
}
