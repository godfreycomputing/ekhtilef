import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/common/app_colors.dart';
import '../../../core/common/dimens.dart';
import '../../../core/common/gaps.dart';
import '../bloc/image_editor_step_bloc.dart';
import '../providers/image_converter_provider.dart';

class ImageEditorFirstStepInitialAddImageWidget extends StatelessWidget {
  final ImageEditorStepBloc imageEditorStepBloc;
  final String path;

  const ImageEditorFirstStepInitialAddImageWidget(
      {Key? key, required this.imageEditorStepBloc, required this.path});

  @override
  Widget build(BuildContext context) {
    final imageConverter =
        Provider.of<ImageConverterProvider>(context, listen: false);
    final imageConverterWatch = Provider.of<ImageConverterProvider>(context);
    final downloadedImage = imageConverterWatch.convertedImage;
    final imageLoading = imageConverterWatch.imageLoading;
    return InkWell(
      onTap: () => imageConverter.urlToImage(path),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              color: AppColors.primaryColorDark,
              size: MediaQuery.of(context).size.width / 3,
            ),
            Gaps.vGap32,
            const Text(
              'Tap anywhere to open a photo',
              style: TextStyle(
                  color: AppColors.primaryColorDark,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimens.font_sp24),
            ),
            imageLoading
                ? const CircularProgressIndicator()
                : Image(image: downloadedImage.image),
          ],
        ),
      ),
    );
  }
}
