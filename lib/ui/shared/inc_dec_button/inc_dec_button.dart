import 'package:flutter/material.dart';
import './controller.dart';
import 'dart:async';

class IncDecButton extends StatefulWidget {
  final IncDecController? controller;
  final Function(int)? onChange;
  final int? initial;
  final int min;
  final int max;
  const IncDecButton(
      {super.key,
      this.controller,
      this.onChange,
      this.initial,
      this.min = 0,
      this.max = 0});

  @override
  State<IncDecButton> createState() => _IncDecButtonState();
}

class _IncDecButtonState extends State<IncDecButton> {
  int _val = 0;
  late Timer _timer;
  bool _isKeyboardEditing = false;
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    _val = widget.initial ?? widget.min;
    _textController = TextEditingController();
    _focusNode = FocusNode();
    widget.controller?.addListener(() {
      _val = widget.controller!.value;
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant IncDecButton oldWidget) {
    if (oldWidget.controller != widget.controller &&
        widget.controller != null) {
      _val = widget.controller!.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void update(int newValue) {
    setState(() {
      if (newValue >= widget.min && newValue <= widget.max) {
        _val = newValue;
      }
    });
    if (widget.onChange != null) widget.onChange!(_val);
    widget.controller?.setValue(_val);
  }

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 100);
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              update(_val - 1);
            },
            onLongPress: () {
              _timer = Timer.periodic(duration, (timer) {
                update(_val - 1);
              });
            },
            onLongPressEnd: (_) {
              _timer.cancel();
            },
            child: const Icon(Icons.remove)),
        if (_isKeyboardEditing)
          ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 50),
              child: IntrinsicWidth(
                  child: TextField(
                focusNode: _focusNode,
                controller: _textController,
                keyboardType: TextInputType.phone,
                onChanged: (value) => setState(() {
                  if (int.tryParse(value) != null) {
                    int newValue = int.parse(value);
                    update(newValue);
                  }
                }),
                onTapOutside: (_) {
                  setState(() {
                    _isKeyboardEditing = false;
                  });
                },
                textAlign: TextAlign.center,
              )))
        else
          TextButton(
            child: Text("$_val"),
            onPressed: () {
              setState(() {
                _textController.text = "$_val";
                _isKeyboardEditing = true;
                _focusNode.requestFocus();
              });
            },
          ),
        GestureDetector(
            onTap: () {
              update(_val + 1);
            },
            onLongPress: () {
              _timer = Timer.periodic(duration, (timer) {
                update(_val + 1);
              });
            },
            onLongPressEnd: (_) {
              _timer.cancel();
            },
            child: const Icon(Icons.add)),
      ],
    );
  }
}
