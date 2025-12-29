import 'package:flutter/material.dart';
import 'state_project.dart';

final List<String> states = [
  'Lagos',
  'FCT',
  'Rivers',
  'Oyo',
  'Kaduna',
];

class StatesTab extends StatelessWidget {
  const StatesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('States')),
      body: ListView.builder(
        itemCount: states.length,
        itemBuilder: (context, index) {
          final state = states[index];

          return ListTile(
            title: Text(state),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProjectsByStateScreen(stateName: state),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
