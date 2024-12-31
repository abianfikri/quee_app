import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:quee_app/core/constants/colors.dart';
import 'package:quee_app/data/datasources/antrian_local_datasources.dart';
import 'package:quee_app/data/datasources/antrian_print.dart';
import 'package:quee_app/data/models/antrian.dart';
import 'package:quee_app/pages/antrian_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Antrian> listAntrian = [];

  Future getAntrian() async {
    final result = await AntrianLocalDatasources.instance.getAllAntrian();
    setState(() {
      listAntrian = result;
    });
  }

  @override
  void initState() {
    getAntrian();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Antrian Kita Bisa',
          style: TextStyle(color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: listAntrian.isEmpty
          ? const Center(
              child: Text('Data Antrian Kosong'),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: listAntrian.length,
              itemBuilder: (context, index) {
                final antrian = listAntrian[index];
                return InkWell(
                  onTap: () async {
                    final noAntrian = antrian.noAntrian.split('-').last;
                    final newAntrian = antrian.copyWith(
                      noAntrian:
                          '${antrian.noAntrian.split('-').first}-${int.parse(noAntrian) + 1}',
                    );
                    final printValue = await AntrianPrint.instance.printAntrian(
                      newAntrian,
                    );
                    await PrintBluetoothThermal.writeBytes(printValue);
                    AntrianLocalDatasources.instance.updateAntrian(newAntrian);
                    getAntrian();
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: AppColors.card,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          antrian.nama,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          antrian.noAntrian,
                          style: const TextStyle(
                            fontSize: 24,
                            color: AppColors.subTitle,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AntrianPage(),
              ));

          getAntrian();
        },
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ),
    );
  }
}
