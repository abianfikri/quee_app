import 'package:flutter/material.dart';
import 'package:quee_app/core/constants/colors.dart';
import 'package:quee_app/data/datasources/antrian_local_datasources.dart';
import 'package:quee_app/data/models/antrian.dart';
import 'package:quee_app/pages/printer_page.dart';

class AntrianPage extends StatefulWidget {
  const AntrianPage({super.key});

  @override
  State<AntrianPage> createState() => _AntrianPageState();
}

class _AntrianPageState extends State<AntrianPage> {
  final TextEditingController _namaController = TextEditingController();
  final _noAntrianController = TextEditingController();
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
  void dispose() {
    _namaController.dispose();
    _noAntrianController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelola Antrian',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return PrinterPage();
                  },
                ));
              },
              icon: Icon(
                Icons.print,
                color: Colors.white,
              ))
        ],
      ),
      body: listAntrian.isEmpty
          ? const Center(
              child: Text("Data Antrian Kosong"),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listAntrian.length,
              itemBuilder: (context, index) {
                final antrian = listAntrian[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: AppColors.card,
                  child: ListTile(
                    title: Text(
                      antrian.nama,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      antrian.noAntrian,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.subTitle,
                      ),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          // Udate
                          showDialog(
                            context: context,
                            builder: (context) {
                              _namaController.text = antrian.nama;
                              _noAntrianController.text = antrian.noAntrian;
                              return AlertDialog(
                                title: Text('Ubah Antrian'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _namaController,
                                      decoration: InputDecoration(
                                          labelText: 'Nama Antrian'),
                                    ),
                                    TextField(
                                      controller: _noAntrianController,
                                      decoration: InputDecoration(
                                          labelText: 'Nomor Antrian'),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      AntrianLocalDatasources.instance
                                          .deleteAntrian(
                                        antrian.id!,
                                      );
                                      getAntrian();
                                      Navigator.pop(context);
                                    },
                                    child: Text('Hapus'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      AntrianLocalDatasources.instance
                                          .updateAntrian(
                                        Antrian(
                                          id: antrian.id,
                                          nama: _namaController.text,
                                          noAntrian: _noAntrianController.text,
                                          isActive: antrian.isActive,
                                        ),
                                      );
                                      getAntrian();
                                      Navigator.pop(context);
                                    },
                                    child: Text('Update'),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.arrow_forward)),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              _namaController.text = '';
              _noAntrianController.text = '';
              return AlertDialog(
                title: Text('Tambah Antrian'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _namaController,
                      decoration: InputDecoration(labelText: 'Nama Antrian'),
                    ),
                    TextField(
                      controller: _noAntrianController,
                      decoration: InputDecoration(labelText: 'Nomor Antrian'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () {
                      AntrianLocalDatasources.instance.saveAntrian(
                        Antrian(
                          nama: _namaController.text,
                          noAntrian: _noAntrianController.text,
                          isActive: true,
                        ),
                      );
                      getAntrian();
                      Navigator.pop(context);
                    },
                    child: Text('Simpan'),
                  )
                ],
              );
            },
          );
        },
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
