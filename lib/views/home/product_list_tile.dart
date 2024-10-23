import 'package:flutter/material.dart';
import 'package:hilaza/utils/constants.dart';

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
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .15,
            child: _buildImage(hilo.fotosHilos?.ruta)),
        ),
        title: Text(hilo.description ?? 'No Description',
        style: const TextStyle(
          color: Consts.morado,
          fontWeight: FontWeight.bold
        ),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código: ${hilo.item}'),
            const Text('Cantidad de conos:'),
            ConosDropdownn(
                      selectedValue: viewModel.selectedQuantities[hilo.cod] ?? 1,
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          viewModel.updateQuantity(hilo.cod!, newValue);
                        }
                      },
                      items: List.generate(30, (i) => i + 1),
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

class ConosDropdownn extends StatelessWidget {
  final int selectedValue;
  final ValueChanged<int?> onChanged;
  final List<int> items;

  const ConosDropdownn({super.key, 
    required this.selectedValue,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .25,
      child: DropdownButtonFormField<int>(
        value: selectedValue,
        items: items.map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
        ),
        dropdownColor: Colors.white,
        icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).primaryColor),
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
