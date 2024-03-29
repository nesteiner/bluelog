import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/api.dart';
import 'package:flutter_frontend/models.dart';
import 'package:flutter_frontend/pages.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import 'globalstate.dart';


class PostShortcutWidget extends StatelessWidget {
  final PostShortcut shortcut;
  final List<String> list = ["Edit", "Delete"];
  late final String dropdownValue = list.first;

  PostShortcutWidget({Key? key, required this.shortcut}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHead(context),
        buildBody(context),
        buildFooter(context)
      ],
    );

    final sizedbox = SizedBox(
      height: 200,
      child: column,
    );

    final clip = ClipRect(
      child: sizedbox,
    );

    final child = Padding(
      padding: const EdgeInsets.all(10),
      child: clip,
    );

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromRGBO(0, 0, 0, 0.125),
              width: 1.0,
              style: BorderStyle.solid
          ),

          borderRadius: const BorderRadius.all(Radius.circular(8.0))
      ),

      margin: EdgeInsets.all(5.0),
      child: child,
    );
  }
  
  Widget buildHead(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Consumer(
            builder: (context, GlobalState state, child) {
              return TextButton(
                child: Text(shortcut.title, style: Theme.of(context).textTheme.headline3,),
                onPressed: () async {
                  try {
                    final post = await state.findPost(shortcut.postid);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => PostView(post: post)));
                  } on DioError catch(error) {
                    handleDioError(context, error);
                  }
                },
              );
            },
        ),

        Consumer(
            builder: (context, GlobalState state, child) {
              return Column(
                children: [
                  TextButton(
                    child: Text("Edit"),
                    onPressed: () async {
                      try {
                        final post = await state.findPost(shortcut.postid);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) =>
                                PostEditPage(post: post)));
                      } on DioError catch(error) {
                        handleDioError(context, error);
                      }
                    },
                  ),

                  TextButton(
                    child: Text("Delete"),
                    onPressed: () async {
                      await state.deletePost(shortcut.postid);
                    },
                  )
                ],
              );
            }
        )
      ],
    );
  }
  
  Widget buildBody(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Html(data: shortcut.shortcut),
    );
  }
  
  Widget buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(shortcut.category.name, style: const TextStyle(color: Colors.blue),),
      ],
    );
  }
}

class Pagination extends StatelessWidget {
  void Function() onPrev;
  void Function() onNext;

  Pagination({
    required this.onPrev,
    required this.onNext
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton(onPressed: onPrev, child: Text("<Previous")),
        TextButton(onPressed: onNext, child: Text("Next>"))
      ],
    );
  }
}