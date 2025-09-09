import 'package:flutter/material.dart';
import 'package:flutter_mandiri/style_and_transition/style/style_font_size.dart';
import 'package:flutter_mandiri/style_and_transition/transition_navigator/transition_UpDown.dart';
import 'package:flutter_mandiri/widget/widget_snack_bar.dart';

class NavigationGesture extends StatefulWidget {
  final List<Map<String, dynamic>> attContent;
  final bool isOpen;
  final VoidCallback close;
  final String currentPage;
  const NavigationGesture({
    super.key,
    required this.attContent,
    required this.isOpen,
    required this.close,
    required this.currentPage,
  });

  @override
  State<NavigationGesture> createState() => _NavigationGestureState();
}

class _NavigationGestureState extends State<NavigationGesture> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: widget.isOpen ? 0 : -290,
      top: 0,
      bottom: 0,
      child: Container(
        margin: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              // offset: Offset(3, 0),
              blurRadius: 10,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        width: 250,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                child: ListTile(
                  onTap: widget.close,
                  leading: Icon(Icons.keyboard_backspace_rounded),
                  title: Text("Tutup", style: lv2TextStyle),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 10),
                  for (var menu in widget.attContent)
                    _navContent(
                      menu['id'],
                      menu['toContext'],
                      menu['text_menu'],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navContent(String id, Widget toContext, String text) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      width: double.infinity,
      color: Colors.transparent,
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            if (widget.currentPage == id) {
              customSnackBar(context, "Anda sudah berada di$text");
            } else {
              navUpDownTransition(context, toContext, true);
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(text, style: lv2TextStyle),
          ),
        ),
      ),
    );
  }
}
