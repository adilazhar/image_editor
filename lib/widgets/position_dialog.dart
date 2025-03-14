import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/providers/text_info_controller.dart';

class PositionDialog extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const PositionDialog({super.key, required this.onClose});

  @override
  ConsumerState<PositionDialog> createState() => _PositionDialogState();
}

class _PositionDialogState extends ConsumerState<PositionDialog> {
  double _positionStep = 5.0; // Default step value
  double _initialPositionStep = 5.0; // Store initial value

  @override
  void initState() {
    super.initState();
    // Initialize with default value
    _positionStep = 5.0;
    _initialPositionStep = _positionStep;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text(
                    'Move By: ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_positionStep.toInt()} px',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: _positionStep,
                      min: 1,
                      max: 20,
                      divisions: 20,
                      onChanged: (value) {
                        setState(() {
                          _positionStep = value;
                        });
                      },
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check,
                            color: Colors.green, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                            width: 24, height: 24),
                        onPressed: widget.onClose,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.red, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                            width: 24, height: 24),
                        onPressed: () {
                          setState(() {
                            _positionStep = _initialPositionStep;
                          });
                          widget.onClose();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(textInfoControllerProvider.notifier)
                          .moveTextByAmount(_positionStep, 'left');
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(textInfoControllerProvider.notifier)
                          .moveTextByAmount(_positionStep, 'up');
                    },
                    child: const Icon(Icons.arrow_upward),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(textInfoControllerProvider.notifier)
                          .moveTextByAmount(_positionStep, 'down');
                    },
                    child: const Icon(Icons.arrow_downward),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(textInfoControllerProvider.notifier)
                          .moveTextByAmount(_positionStep, 'right');
                    },
                    child: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
