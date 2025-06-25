import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pegawai/model/dosen_model.dart';

class ApiService {
  static const baseUrl = 'http://192.168.50.1:8000/api/dosen';

  /// GET: Ambil semua dosen
  static Future<List<Dosen>> fetchDosen() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      List data = json.decode(res.body);
      return data.map((e) => Dosen.fromJson(e)).toList();
    }
    throw Exception('Gagal mengambil data dosen');
  }

  /// POST: Tambah dosen 
  static Future<Map<String, dynamic>> tambahDosen(Dosen dosen) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(dosen.toJson()),
    );

    if (res.statusCode == 201) {
      return {
        'success': true,
        'message': 'Berhasil menambahkan data dosen',
      };
    } else {
      try {
        final body = json.decode(res.body);
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal menambahkan data',
        };
      } catch (_) {
        return {
          'success': false,
          'message': 'Gagal menambahkan data (response tidak dikenali)',
        };
      }
    }
  }

  /// PUT: Update dosen
  static Future<Map<String, dynamic>> updateDosen(int no, Dosen dosen) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$no'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(dosen.toJson()),
    );

    if (res.statusCode == 200) {
      return {
        'success': true,
        'message': 'Berhasil memperbarui data dosen',
      };
    } else {
      try {
        final body = json.decode(res.body);
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal update data',
        };
      } catch (_) {
        return {
          'success': false,
          'message': 'Gagal update data (response tidak dikenali)',
        };
      }
    }
  }

  /// DELETE: Hapus dosen
  static Future<Map<String, dynamic>> deleteDosen(int no) async {
    final res = await http.delete(Uri.parse('$baseUrl/$no'));

    if (res.statusCode == 200) {
      return {
        'success': true,
        'message': 'Data dosen berhasil dihapus',
      };
    } else {
      try {
        final body = json.decode(res.body);
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal menghapus data',
        };
      } catch (_) {
        return {
          'success': false,
          'message': 'Gagal menghapus data (response tidak dikenali)',
        };
      }
    }
  }
}
