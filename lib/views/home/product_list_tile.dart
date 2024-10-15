import 'package:flutter/material.dart';

import '../../models/yarn_model.dart';
import '../../viewmodels/home_viewmodel.dart';


class ProductListTile extends StatelessWidget {
  final Hilo hilo;
  final HomeViewModel viewModel;
  final Function(Hilo) onTap;

  const ProductListTile({
    super.key,
    required this.hilo,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(hilo.cod),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _buildImage(hilo.fotosHilos?.ruta),
        ),
        title: Text(hilo.description ?? 'No Description'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código: ${hilo.cod}'),
            const Text('Cantidad de conos:'),
            DropdownButton<int>(
              value: viewModel.selectedQuantities[hilo.cod] ?? 1,
              items: List.generate(30, (i) => i + 1).map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  viewModel.updateQuantity(hilo.cod!, newValue);
                }
              },
            ),
          ],
        ),
        trailing: Checkbox(
          value: viewModel.selectedProducts.contains(hilo),
          onChanged: (bool? value) {
            viewModel.toggleSelection(hilo);
          },
        ),
        onTap: () => onTap(hilo),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return imageUrl != null && imageUrl.isNotEmpty
        ? Image.network(imageUrl)
        : Image.asset('assets/placeholder.png', width: 80, height: 100, fit: BoxFit.cover);
  }
}
