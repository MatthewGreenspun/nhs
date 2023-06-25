import 'package:flutter/material.dart';
import 'dart:async';

class IncDecButton extends StatefulWidget {
  final int min;
  final int max;
  const IncDecButton({super.key, this.min = 0, this.max = 0});

  @override
  State<IncDecButton> createState() => _IncDecButtonState();
}

class _IncDecButtonState extends State<IncDecButton> {
  int _val = 0;
  late Timer _timer;
  bool _isKeyboardEditing = false;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 100);
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              setState(() {
                _val--;
              });
            },
            onLongPress: () {
              _timer = Timer.periodic(duration, (timer) {
                setState(() {
                  _val--;
                });
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
                controller: _controller,
                keyboardType: TextInputType.phone,
                onChanged: (value) => setState(() {
                  if (int.tryParse(value) != null) {
                    _val = int.parse(value);
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
                _controller.text = "$_val";
                _isKeyboardEditing = true;
                _focusNode.requestFocus();
              });
            },
          ),
        GestureDetector(
            onTap: () {
              setState(() {
                _val++;
              });
            },
            onLongPress: () {
              _timer = Timer.periodic(duration, (timer) {
                setState(() {
                  _val++;
                });
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
