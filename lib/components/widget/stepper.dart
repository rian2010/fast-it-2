import 'package:flutter/material.dart';

class StepperPage extends StatefulWidget {
  const StepperPage({super.key});

  @override
  State<StepperPage> createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  int currentStep = 0;

  continueStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep = currentStep + 1;
      });
    }
  }

  cancelStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep = currentStep - 1;
      });
    }
  }

  onStepTapped(int value) {
    setState(() {
      currentStep = value;
    });
  }

  Widget controlBuilders(context, details) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: details.onStepContinue,
            child: const Text('Next'),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: details.onStepCancel,
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proses'),
        backgroundColor: const Color(0xFF1CC2CD),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stepper(
            elevation: 0,
            controlsBuilder: controlBuilders,
            type: StepperType.vertical,
            physics: const ScrollPhysics(),
            onStepTapped: onStepTapped,
            onStepContinue: continueStep,
            onStepCancel: cancelStep,
            currentStep: currentStep,
            steps: [
              Step(
                title: const Text('Step 1'),
                content: const Column(
                  children: [
                    Text('This is the first step.'),
                  ],
                ),
                isActive: currentStep >= 0,
                state:
                    currentStep >= 0 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: const Text('Step 2'),
                content: const Text('This is the Second step.'),
                isActive: currentStep >= 0,
                state:
                    currentStep >= 1 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: const Text('Step 3'),
                content: const Text('This is the Third step.'),
                isActive: currentStep >= 0,
                state:
                    currentStep >= 2 ? StepState.complete : StepState.disabled,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
