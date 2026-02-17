import 'package:flutter_test/flutter_test.dart';
import 'package:meilisearch/meilisearch.dart';

void main() {
  test('Testar Conexão e busca no milisearch', () async {
    final meiliClient = MeiliSearchClient(
      'https://shared-meredith-carboneto-2c512dda.koyeb.app/',
      'EDWxYEAJrvPoHIR-gHJSNS3-p6J80XASaechuGNXYIo',
    );

    final index = meiliClient.index('exercises_index');

    final searchTerm = 'stepback';
    print('Buscando por ${searchTerm}');

    try {
      final result = await index.search(searchTerm);
      print('✅ Busca finalizada com sucesso!');
      print('Tempo de resposta: ${result.processingTimeMs} ms');
      print('Total de itens encontrados: ${result.hits.length}');
      print('--- RESULTADOS ---');

      for (var item in result.hits) {
        print(item);
      }

      expect(result, isNotNull);


    } catch (e) {
      print('Erro ao buscar: $e');
      fail('O teste falhou.');
    }


    
  });
}