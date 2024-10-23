import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hilaza/views/home/home_screen.dart';
import 'package:hilaza/views/widgets/elevated_button.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_viewmodel.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PrintListScreen extends StatefulWidget {
  const PrintListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PrintListScreenState createState() => _PrintListScreenState();
}

class _PrintListScreenState extends State<PrintListScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
      title: const Text(
        'Imprimir Lista de Hilos',
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .04),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: (_isLoading)
      ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
      : Column(
        children: [
          Expanded(
            flex: 2,
            child: Image.asset(
              'assets/printer.gif',
              fit: BoxFit.contain,
            ),
          ),
          Flexible(
            child: SizedBox(
              width: double.infinity,
              child: MainButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    final pdf = await generatePdf(context);
                    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                text: 'Mandar a imprimir',
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
          Flexible(
            child: TextButton(
              onPressed: () {
                // Reset values in HomeViewModel
                Provider.of<HomeViewModel>(context, listen: false).resetValues();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Regresar a pantalla principal'),
            ),
          ),
        ],
      ),
    );
  }
}

Future<pw.Document> generatePdf(BuildContext context) async {
  final viewModel = Provider.of<HomeViewModel>(context, listen: false);
  final pdf = pw.Document();

  // Construir la tabla completa con todos los elementos
  final List<List<dynamic>> data = [];

  for (var hilo in viewModel.selectedProducts) {
    final image1 = (hilo.fotosHilos?.ruta != null && hilo.fotosHilos!.ruta!.isNotEmpty)
        ? await networkImage(hilo.fotosHilos!.ruta!)
        : null;
    final image2 = (hilo.fotosDescripcionesHilos?.ruta != null && hilo.fotosDescripcionesHilos!.ruta!.isNotEmpty)
        ? await networkImage(hilo.fotosDescripcionesHilos!.ruta!)
        : null;

    data.add([
      viewModel.selectedTeamName ?? '',
      hilo.description ?? '',
      hilo.item ?? '',
      viewModel.selectedQuantities[hilo.cod]?.toString() ?? '0',
      image1 != null ? pw.Image(pw.MemoryImage(image1), height: 50, width: 50) : 'No Image',
      image2 != null ? pw.Image(pw.MemoryImage(image2), height: 50, width: 50) : 'No Image',
    ]);
  }

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.TableHelper.fromTextArray(
          headers: ['TEAMS', 'DESCRIPCION', 'ITEM', 'CANTIDAD DE CONOS', 'HILO', 'DESCRIPCIÓN'],
          data: data,
          headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
          cellAlignment: pw.Alignment.center,
          columnWidths: {
            0: const pw.FixedColumnWidth(50),
            1: const pw.FixedColumnWidth(110),
            2: const pw.FixedColumnWidth(105),
            3: const pw.FixedColumnWidth(65),
            4: const pw.FixedColumnWidth(80),
            5: const pw.FixedColumnWidth(80),
          },
        );
      },
    ),
  );

  return pdf;
}

Future<Uint8List> networkImage(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Error al cargar la imagen');
  }
}
