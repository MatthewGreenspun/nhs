import 'package:flutter/material.dart';

class FilterChips extends StatefulWidget {
  final List<String> labels;
  final Function(String) onSelected;
  const FilterChips(
      {super.key, required this.labels, required this.onSelected});

  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  late ScrollController _chipController;
  final List<GlobalKey> _chipKeys = [];
  int _selectedChip = 0;

  @override
  void initState() {
    _chipKeys.addAll(List.generate(widget.labels.length,
        (idx) => GlobalKey(debugLabel: widget.labels[idx])));
    _chipController = ScrollController();
    super.initState();
  }

  double computeChipScrollOffset(int chipIdx) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final maxScroll = _chipController.position.maxScrollExtent;
    RenderBox box =
        _chipKeys[chipIdx].currentContext?.findRenderObject() as RenderBox;
    final itemSize = box.size.width;
    Offset position = box.localToGlobal(Offset.zero);
    final desiredPosition = deviceWidth / 2 - itemSize / 2;
    final change = position.dx - desiredPosition;
    if (change + _chipController.offset < 0) {
      return 0;
    }
    if (change + _chipController.offset > maxScroll) {
      return maxScroll;
    }
    return change + _chipController.offset;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _chipController,
      scrollDirection: Axis.horizontal,
      children: widget.labels.asMap().entries.map(
        (entry) {
          final idx = entry.key;
          return Container(
              key: _chipKeys[idx],
              margin: const EdgeInsets.symmetric(
                horizontal: 4,
              ),
              child: ActionChip(
                label: Text(entry.value),
                backgroundColor: idx == _selectedChip
                    ? Theme.of(context).colorScheme.secondary
                    : null,
                onPressed: () {
                  setState(() {
                    _selectedChip = idx;
                    widget.onSelected(widget.labels[_selectedChip]);
                  });
                  if (_chipKeys.any((e) => e.currentContext == null)) {
                    return;
                  }
                  _chipController.animateTo(computeChipScrollOffset(idx),
                      curve: Curves.decelerate,
                      duration: const Duration(milliseconds: 200));
                },
              ));
        },
      ).toList(),
    );
  }
}
