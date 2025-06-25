import 'package:flutter/material.dart';
import 'package:pegawai/model/dosen_model.dart';
import '../service/api_service.dart';

class TambahDosenScreen extends StatefulWidget {
  @override
  _TambahDosenScreenState createState() => _TambahDosenScreenState();
}

class _TambahDosenScreenState extends State<TambahDosenScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nipController = TextEditingController();
  final _namaController = TextEditingController();
  final _teleponController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    Dosen newDosen = Dosen(
      no: 0,
      nip: _nipController.text,
      namaLengkap: _namaController.text,
      noTelepon: _teleponController.text,
      email: _emailController.text,
      alamat: _alamatController.text,
    );

    final result = await ApiService.tambahDosen(newDosen);

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success']
              ? '💖 Data dosen berhasil ditambahkan!'
              : '🚫 ${result['message'] ?? 'Gagal menambahkan data'}',
        ),
        backgroundColor: result['success'] ? Colors.pink : Colors.red,
      ),
    );

    if (result['success']) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Dosen"),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _submitForm,
            tooltip: "Simpan",
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.pink))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _inputField("NIP", _nipController, Icons.badge),
              _inputField("Nama Lengkap", _namaController, Icons.person),
              _inputField("No Telepon", _teleponController, Icons.phone),
              _inputField("Email", _emailController, Icons.email),
              _inputField("Alamat", _alamatController, Icons.home, maxLines: 3),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.favorite),
                  label: Text("Simpan Dosen"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, IconData icon,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.pink),
          filled: true,
          fillColor: Colors.pink.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? '$label tidak boleh kosong' : null,
      ),
    );
  }
}