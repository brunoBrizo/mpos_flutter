import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum CustomAnimationType { slide, rotation, size }

class AnimatedImage extends StatefulWidget {
  final String imageToAnimate;
  final double imageSizeToAnimate;
  final int animationDuration;
  final CustomAnimationType animationType;
  const AnimatedImage({
    Key key,
    this.imageToAnimate,
    this.imageSizeToAnimate,
    this.animationDuration,
    this.animationType,
  }) : super(key: key);

  @override
  _AnimatedImageState createState() => _AnimatedImageState(
      imageToAnimate, imageSizeToAnimate, animationDuration, animationType);
}

class _AnimatedImageState extends State<AnimatedImage>
    with SingleTickerProviderStateMixin {
  String imageToAnimate;
  double imageSizeToAnimate;
  int animationDuration;
  CustomAnimationType animationType;

  AnimationController _controller;
  Animation<Offset> _animation;
  Animation<double> _animationDouble;

  _AnimatedImageState(this.imageToAnimate, this.imageSizeToAnimate,
      this.animationDuration, this.animationType);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: animationDuration))
      ..repeat(reverse: true);
    _animation = Tween(begin: Offset.zero, end: const Offset(0, 0.15)).animate(
        CurvedAnimation(parent: _controller, curve: Curves.decelerate));
    _animationDouble = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AnimatedWidget transition;
    switch (animationType) {
      case CustomAnimationType.slide:
        transition = SlideTransition(
          position: _animation,
          child: Image.asset(
            imageToAnimate,
            color: Color.fromRGBO(255, 255, 255, 1),
            height: imageSizeToAnimate,
          ),
        );
        break;
      case CustomAnimationType.rotation:
        transition = RotationTransition(
          turns: Tween(begin: 0.0, end: 0.5).animate(
              CurvedAnimation(parent: _controller, curve: Curves.decelerate)),
          child: Image.asset(
            imageToAnimate,
            color: Color.fromRGBO(255, 255, 255, 1),
            height: imageSizeToAnimate,
          ),
        );
        break;
      default:
        transition = SizeTransition(
          sizeFactor: _animationDouble,
          child: Image.asset(
            imageToAnimate,
            color: Color.fromRGBO(255, 255, 255, 1),
            height: imageSizeToAnimate,
          ),
        );
        break;
    }
    return transition;
  }
}
