import 'package:flutter/material.dart';
import 'package:hilaza/views/home/home_screen.dart';
import 'package:provider/provider.dart';

import '../viewmodels/home_viewmodel.dart';

class PrintListScreen extends StatelessWidget {
  const PrintListScreen({super.key});

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
      child: Column(
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
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Mandar a imprimir'),
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

