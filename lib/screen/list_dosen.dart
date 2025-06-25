import 'package:flutter/material.dart';
import 'package:pegawai/model/dosen_model.dart';
import 'package:pegawai/service/api_service.dart';
import 'tambah_dosen.dart';
import 'edit_dosen.dart';
import 'package:iconsax/iconsax.dart';

class ListDosenScreen extends StatefulWidget {
  @override
  _ListDosenScreenState createState() => _ListDosenScreenState();
}

class _ListDosenScreenState extends State<ListDosenScreen> {
  late Future<List<Dosen>> dosenList;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      dosenList = ApiService.fetchDosen();
    });
  }

  void _hapus(int no) async {
    final confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("Hapus Dosen", style: TextStyle(color: Colors.pink)),
        content: Text("Yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
              child: Text("Batal"), onPressed: () => Navigator.pop(ctx, false)),
          TextButton(
            child: Text("Hapus", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final result = await ApiService.deleteDosen(no);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] ? Colors.pink : Colors.red,
        ),
      );
      if (result['success']) _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        backgroundColor: Colors.pink,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Iconsax.teacher, color: Colors.white),
            SizedBox(width: 8),
            Text('Data Dosen'),
          ],
        ),
      ),
      body: FutureBuilder<List<Dosen>>(
        future: dosenList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.pink));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat data'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada data dosen."));
          }

          final list = snapshot.data!;
          return RefreshIndicator(
            color: Colors.pink,
            onRefresh: () async => _refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final d = list[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade100,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    leading: CircleAvatar(
                      backgroundColor: Colors.pink.shade100,
                      child: Icon(Iconsax.profile_circle, color: Colors.white),
                    ),
                    title: Text(
                      d.namaLengkap,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('NIP: ${d.nip}\n${d.email}',
                        style: const TextStyle(color: Colors.grey)),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Iconsax.edit_2, color: Colors.pink),
                          onPressed: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => EditDosenScreen(dosen: d)),
                            );
                            if (updated == true) _refresh();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Iconsax.trash, color: Colors.redAccent),
                          onPressed: () => _hapus(d.no),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pink,
        icon: const Icon(Iconsax.add_circle),
        label: const Text("Tambah"),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahDosenScreen()),
          );
          if (result == true) _refresh();
        },
      ),
    );
  }
}
