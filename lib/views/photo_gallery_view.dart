import 'package:bloc_course_with_firebase/bloc/app_bloc.dart';
import 'package:bloc_course_with_firebase/bloc/app_event.dart';
import 'package:bloc_course_with_firebase/bloc/app_state.dart';
import 'package:bloc_course_with_firebase/views/popup_menu_button.dart';
import 'package:bloc_course_with_firebase/views/sotrage_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGalleryView extends HookWidget {
  const PhotoGalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final d = useContext();
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.watch<AppBloc>().state.images ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          IconButton(
            onPressed: () async {
              final image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null && context.mounted) {
                context.read<AppBloc>().add(
                  AppEventUpLoadImage(filePathToUpload: image.path),
                );
              } else {
                return;
              }
            },
            icon: const Icon(Icons.upload),
          ),
          const MainPopupMenuButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            children: images
                .map(
                  (img) => StorageImageView(
                    image: img,
                  ),
                )
                .toList()),
      ),
    );
  }
}
