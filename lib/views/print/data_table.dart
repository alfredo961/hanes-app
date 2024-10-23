import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/home_viewmodel.dart';

class MyDataTable extends StatelessWidget {
  const MyDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('TEAMS')),
          DataColumn(label: Text('DESCRIPCION')),
          DataColumn(label: Text('CÓDIGO')),
          DataColumn(label: Text('CANTIDAD DE CONOS')),
          DataColumn(label: Text('HILO')),
          DataColumn(label: Text('DESCRIPCIÓN')),
        ],
        rows: viewModel.selectedProducts.map((hilo) {
          return DataRow(cells: [
            DataCell(Text(viewModel.selectedTeamName ?? '')),
            DataCell(Text(hilo.description ?? '')),
            DataCell(Text(hilo.item ?? '')),
            DataCell(Text(viewModel.selectedQuantities[hilo.cod]?.toString() ?? '0')),
            DataCell(hilo.fotosHilos != null && hilo.fotosHilos!.ruta != null
                ? Image.network(hilo.fotosHilos!.ruta!)
                : const Text('No Image')),
            DataCell(hilo.fotosDescripcionesHilos != null && hilo.fotosDescripcionesHilos!.ruta != null
                ? Image.network(hilo.fotosDescripcionesHilos!.ruta!)
                : const Text('No Image')),
          ]);
        }).toList(),
      ),
    );
  }
}