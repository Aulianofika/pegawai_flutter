import 'package:flutter/material.dart';
import 'package:pegawai/model/dosen_model.dart';
import 'package:pegawai/service/api_service.dart';

class EditDosenScreen extends StatefulWidget {
  final Dosen dosen;

  const EditDosenScreen({super.key, required this.dosen});

  @override
  _EditDosenScreenState createState() => _EditDosenScreenState();
}

class _EditDosenScreenState extends State<EditDosenScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nip, _nama, _telp, _email, _alamat;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nip = TextEditingController(text: widget.dosen.nip);
    _nama = TextEditingController(text: widget.dosen.namaLengkap);
    _telp = TextEditingController(text: widget.dosen.noTelepon);
    _email = TextEditingController(text: widget.dosen.email);
    _alamat = TextEditingController(text: widget.dosen.alamat);
  }

  void _update() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      final updated = Dosen(
        no: widget.dosen.no,
        nip: _nip.text,
        namaLengkap: _nama.text,
        noTelepon: _telp.text,
        email: _email.text,
        alamat: _alamat.text,
      );

      final result = await ApiService.updateDosen(widget.dosen.no, updated);

      setState(() => _loading = false);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message']), backgroundColor: Colors.pink),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: const Text('Edit Dosen'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _inputField('NIP', _nip),
              _inputField('Nama Lengkap', _nama),
              _inputField('No Telepon', _telp),
              _inputField('Email', _email),
              _inputField('Alamat', _alamat, maxLines: 2),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: _loading
                    ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
                    : const Text('Simpan Perubahan'),
                onPressed: _loading ? null : _update,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.pink.shade700),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pink.shade300, width: 2),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          fillColor: Colors.white,
          filled: true,
        ),
        validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
      ),
    );
  }
}
