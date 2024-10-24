import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../home/home_screen.dart';
import '../widgets/elevated_button.dart';
import 'package:path_provider/path_provider.dart';

class PrintListScreen extends StatefulWidget {
  const PrintListScreen({super.key});
  @override
  _PrintListScreenState createState() => _PrintListScreenState();
}

class _PrintListScreenState extends State<PrintListScreen> {
  bool _isLoading = false;
  late Future<pw.Document> pdfFuture;

  @override
  void initState() {
    super.initState();
    pdfFuture = _generatePdf();
  }

  Future<pw.Document> _generatePdf() async {
    return await generatePdf(context, 1);
  }

  Future<void> _sendPrintRequest() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final pdf = await pdfFuture;
      final bytes = await pdf.save();
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/archivo.pdf';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      print('Ruta del archivo PDF: $filePath'); // Imprimir la ruta del archivo

      if (await file.exists()) {
        final orderNumber = await Provider.of<HomeViewModel>(context, listen: false).sendPrintRequest(filePath);
        // Obtener el nombre del equipo seleccionado
        final teamName = Provider.of<HomeViewModel>(context, listen: false).selectedTeamName ?? 'equipo';
        // Generar el nombre del archivo PDF
        final newFileName = 'imprimir_orden_${orderNumber}_$teamName.pdf';
        final newFilePath = '${directory.path}/$newFileName';
        // Regenerar el PDF con el número de orden
        final updatedPdf = await generatePdf(context, orderNumber);
        await File(newFilePath).writeAsBytes(await updatedPdf.save());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impresión enviada correctamente. Número de Orden: $orderNumber')),
        );
      } else {
        throw Exception('No se pudo guardar el archivo PDF');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar la impresión: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .04),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: (_isLoading)
          ? const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator.adaptive(),
          Text('Imprimiendo...', textAlign: TextAlign.center),
        ],
      )
          : FutureBuilder<pw.Document>(
        future: pdfFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator.adaptive(),
                Text('Generando PDF...', textAlign: TextAlign.center),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al generar el PDF: ${snapshot.error}'));
          } else {
            final pdf = snapshot.data!;
            return Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .02),
                Expanded(
                  flex: 6,
                  child: PdfPreview(build: (format) => pdf.save()),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .02),
                Flexible(
                  child: SizedBox(
                    width: double.infinity,
                    child: MainButton(
                      onPressed: _sendPrintRequest,
                      text: 'Mandar a imprimir',
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .01),
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
            );
          }
        },
      ),
    );
  }
}

Future<pw.Document> generatePdf(BuildContext context, int orderNumber) async {
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
        return pw.Column(
          children: [
            pw.Text('Número de Orden: $orderNumber', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
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
            ),
          ],
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
