import 'package:flutter/material.dart';
import 'package:hilaza/views/teams_screen.dart';
import 'package:hilaza/views/widgets/elevated_button.dart';
import 'package:provider/provider.dart';

import '../viewmodels/home_viewmodel.dart';

class ConfirmationScreen extends StatelessWidget {
  final int orderNumber;

  const ConfirmationScreen({super.key, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orden Completada'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'La orden de impresión se completó exitosamente.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Número de Orden: $orderNumber',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text(
              'Teams: ${viewModel.selectedTeamName}',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            MainButton(
              onPressed: () {
                viewModel.clearSelectedProducts();
                viewModel.clearTeamSelection();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const TeamsScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              text: 'Crear una nueva orden',
            ),
          ],
        ),
      ),
    );
  }
}
