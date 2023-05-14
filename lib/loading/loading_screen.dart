import 'dart:async';
import 'package:flutter/material.dart';

import 'loading_screen_controller.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static late final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;


  LoadingScreenController? controller;

  LoadingScreenController _showOverlay({
    required BuildContext context,
    required String string,
  }) {
    final text = StreamController<String>();
    text.add(string);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10.0),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20.0),
                    StreamBuilder<String>(
                      stream: text.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!,
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    state.insert(overlay);
    return LoadingScreenController(
      close: () {
        text.close();
        overlay.remove();
        return true;
      },
      update: (string) {
        text.add(string);
        return true;
      },
    );
  }

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = _showOverlay(
        context: context,
        string: text,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }
}
