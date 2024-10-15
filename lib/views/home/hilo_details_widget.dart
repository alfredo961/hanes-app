import 'package:flutter/material.dart';

import '../../models/yarn_model.dart';

class HiloDetailsWidget extends StatelessWidget {
  final Hilo hilo;

  const HiloDetailsWidget({super.key, required this.hilo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Detalles del Hilo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailImage(hilo.fotosHilos?.ruta),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.code, 'Código', hilo.cod, context),
                    const SizedBox(height: 10),
                    _buildDetailRow(Icons.description, 'Descripción',
                        hilo.description, context),
                    const SizedBox(height: 10),
                    _buildDetailRow(
                        Icons.person, 'Vendor', hilo.vendor, context),
                    const SizedBox(height: 10),
                    _buildDetailRow(
                        Icons.category, 'Tipo de hilo', hilo.yarnType, context),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailImage(hilo.fotosDescripcionesHilos?.ruta),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: const Text('Cerrar detalle',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      IconData icon, String label, String? value, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 10),
            Text(
              '$label:',
              style:const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value ?? '',
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,),
        ),
      ],
    );
  }

  Widget _buildDetailImage(String? imageUrl) {
    return imageUrl != null
        ? Image.network(
            imageUrl,
            fit: BoxFit.contain,
          )
        : const SizedBox.shrink();
  }
}
