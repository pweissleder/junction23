import 'dart:async';
import 'dart:math';

class StepData {
  final int totalSteps;
  final DateTime timestamp;

  StepData(this.totalSteps, this.timestamp);
}

class StepSimulator {
  late StreamController<StepData> _stepController;
  late Random _random;
  late Timer _timer;
  late int _currentSteps;

  StepSimulator() {
    _stepController = StreamController<StepData>();
    _random = Random();
    _currentSteps = 0;
    _startSimulation();
  }

  Stream<StepData> get stepStream => _stepController.stream;

  void _startSimulation() {
    const Duration interval = Duration(seconds: 2);

    _timer = Timer.periodic(interval, (timer) {
      _currentSteps += _random.nextInt(20); // Simulate random steps
      DateTime now = DateTime.now();
      StepData stepData = StepData(_currentSteps, now);
      _stepController.add(stepData);
    });
  }

  void stopSimulation() {
    _timer.cancel();
    _stepController.close();
  }
}
