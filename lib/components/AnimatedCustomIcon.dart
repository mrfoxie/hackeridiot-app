import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class AnimatedCustomIcon extends StatefulWidget {
  static String tag = '/AnimatedCustomIcon';
  final Function onPressed;
  final AnimatedIconData icon;
  final double size;
  final Color color;
  bool isPlaying;

  AnimatedCustomIcon({this.onPressed, this.icon, this.size, this.color, this.isPlaying});

  @override
  AnimatedCustomIconState createState() => AnimatedCustomIconState();
}

class AnimatedCustomIconState extends State<AnimatedCustomIcon> with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    animationController = AnimationController(vsync: this, duration: 400.milliseconds);

    await Future.delayed(Duration(milliseconds: 300));
    if (widget.isPlaying.validate()) {
      animationController.forward();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: widget.icon,
        progress: animationController,
        color: widget.color,
        size: widget.size,
      ),
      onPressed: () {
        widget.isPlaying ? animationController.reverse() : animationController.forward();
        widget.isPlaying = !widget.isPlaying;

        widget.onPressed.call();
      },
    );
  }
}
