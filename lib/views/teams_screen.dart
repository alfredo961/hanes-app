import 'package:flutter/material.dart';
import 'package:hilaza/views/widgets/bottom_navigation_space.dart';
import 'package:provider/provider.dart';
import '../utils/is_tablet.dart';
import '../viewmodels/home_viewmodel.dart';
import 'home/home_screen.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().selectTeam('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          'Teams',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Seleccione un Teams',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Consumer<HomeViewModel>(
                  builder: (context, homeViewModel, child) {
                    if (homeViewModel.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (homeViewModel.teams.isEmpty) {
                      return const Center(child: Text('No hay Teams disponibles'));
                    }

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isTablet(context) ? 6 : 5,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemCount: homeViewModel.teams.length,
                      itemBuilder: (context, index) {
                        final team = homeViewModel.teams[index];
                        return GestureDetector(
                          onTap: () {
                            homeViewModel.selectTeam(team.nombre ?? 'No Name');
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          },
                          child: Card(
                            color: _getColor(team.color),
                            child: Center(
                              child: Text(
                                team.nombre ?? 'No Name',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const BottomNavigationSpace()
            ],
          ),
        ),
      ),
    );
  }

  Color _getColor(String? color) {
    switch (color?.toUpperCase()) {
      case 'NARANJA':
        return Colors.orange;
      case 'GRIS':
        return Colors.grey;
      case 'AZUL':
        return Colors.blue;
      case 'VERDE':
        return Colors.green;
      default:
        return Colors.black; 
    }
  }
}