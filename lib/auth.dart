import 'dart:convert';
import 'dart:io';

class AuthService {
  static final String baseUrl = "http://191.96.79.187:4000";
  
  static Future<Map<String, dynamic>> login(String cpf, String senha) async {
    try {
      final cpfLimpo = cpf.replaceAll(RegExp(r'[^0-9]'), '');
      
      final client = HttpClient();
      final request = await client.postUrl(Uri.parse("$baseUrl/login"));
      
      request.headers.set('Content-Type', 'application/x-www-form-urlencoded');
      
      final body = 'cpf=${Uri.encodeComponent(cpfLimpo)}&senha=${Uri.encodeComponent(senha)}';
      request.write(body);
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        return {
          'success': data['success'] ?? false,
          'message': data['message'] ?? '',
          'id': data['id']?.toString() ?? '',
          'cpf': cpfLimpo,
          'nome_completo': data['nome']?.toString() ?? 'Usuário',
          'email': data['email']?.toString() ?? '',
        };
      } else {
        return {
          'success': false,
          'message': 'Erro no servidor (${response.statusCode})',
        };
      }
    } catch (e) {
      print('Erro na conexão: $e');
      return {
        'success': false,
        'message': 'Falha de conexão. Verifique sua internet.',
      };
    }
  }
  
  static Future<List<String>> getCNHImages(String cpf) async {
    try {
      final cpfLimpo = cpf.replaceAll(RegExp(r'[^0-9]'), '');
      
      return [
        'https://datasistemas.online/api/uploads/${cpfLimpo}img1.png',
        'https://datasistemas.online/api/uploads/${cpfLimpo}img2.png',
        'https://datasistemas.online/api/uploads/${cpfLimpo}img3.png',
        'https://datasistemas.online/api/uploads/${cpfLimpo}qrimg5.png',
      ];
    } catch (e) {
      print('Erro ao gerar URLs: $e');
      return [];
    }
  }
}