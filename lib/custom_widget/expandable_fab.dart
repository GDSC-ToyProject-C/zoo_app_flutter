import 'package:flutter/material.dart';
import 'dart:math';

class ParentActionButton extends StatefulWidget {
  final double distance;
  final List<Widget> children;

  const ParentActionButton({required this.distance, required this.children});

  @override
  _ParentActionButtonState createState() => _ParentActionButtonState();
}

class _ParentActionButtonState extends State<ParentActionButton>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _fabController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    _fabController = AnimationController(
      value: _isOpen ? 1.0 : 0.0,
      duration: Duration(milliseconds: 80),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _fabController,
      curve: Curves.fastOutSlowIn,
    );
    super.initState();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        //자식이 부모 뒤에 숨어야하므로 0번째부터 삽입
        children: [_rotateFab()]..insertAll(0, _buildExpandableActionButton()),
      ),
    );
  }

  //자식 fab생성
  List<_ExpandableActionButton> _buildExpandableActionButton() {
    List<_ExpandableActionButton> animChildren = [];
    final int count = widget.children.length;

    for (var i = 0, degree = 10.0; i < count; i++, degree += 70) {
      animChildren.add(_ExpandableActionButton(
        distance: widget.distance,
        progress: _expandAnimation,
        child: widget.children[i],
        degree: degree,
      ));
    }
    return animChildren;
  }

  //부모 fab생성
  Widget _rotateFab() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff707070), width: 1),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: const Color(0xcc000000),
              offset: Offset(0, 3),
              blurRadius: 6,
              spreadRadius: 0),
        ],
        color: const Color(0xffa69988),
      ),
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        duration: Duration(milliseconds: 100),
        transform: Matrix4.rotationZ(_isOpen ? pi / 4 : 0),
        child: FloatingActionButton(
          backgroundColor: _isOpen ? Color(0xfff5f5f5) : Color(0xffa69988),
          onPressed: toggle,
          child: Icon(
            Icons.add_box_rounded,
            color: _isOpen ? Color(0xffa69988) : Color(0xfff5f5f5),
          ),
        ),
      ),
    );
  }

  void toggle() {
    _isOpen = !_isOpen;
    setState(() {
      _isOpen ? _fabController.forward() : _fabController.reverse();
    });
  }
}

//자식 fab들이 펼져지는 애니메이션
class _ExpandableActionButton extends StatelessWidget {
  final double distance;
  final double degree;
  final Animation<double> progress;
  final Widget child;

  const _ExpandableActionButton({
    required this.distance,
    required this.degree,
    required this.progress,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: progress,
        child: child,
        builder: (context, child) {
          final Offset offset = Offset.fromDirection(
              degree * (pi / 180), progress.value * distance);
          return Positioned(
            right: offset.dx + 1,
            bottom: offset.dy + 3,
            child: child!,
          );
        });
  }
}
