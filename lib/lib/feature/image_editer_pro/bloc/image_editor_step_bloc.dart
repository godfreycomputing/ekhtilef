import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gallery_saver/gallery_saver.dart';

part 'image_editor_step_event.dart';

part 'image_editor_step_state.dart';

class ImageEditorStepBloc
    extends Bloc<ImageEditorStepEvent, ImageEditorStepState> {
  ImageEditorStepBloc() : super(const ImageEditorFirstStepInitialAddImageState());

  List<File> listOfEditingImage= <File>[];
  final List<int> _height = <int>[];
  final List<int> _width = <int>[];
  int counter = 1;
  
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
          albumName: 'TShirt'
      );
      /// Save box ima
      await GallerySaver.saveImage(
          event.boxImage.path,
          albumName: 'TShirt'
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
