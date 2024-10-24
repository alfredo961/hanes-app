import 'package:flutter/material.dart';
import 'package:hilaza/views/home/home_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  final int orderNumber;

  const ConfirmationScreen({super.key, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orden Completada'),
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
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Crear una nueva orden'),
            ),
          ],
        ),
      ),
    );
  }
}
