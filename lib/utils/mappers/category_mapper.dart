class CategoryMapper {
  static const String fallback = 'Outros';

  static final Map<String, String> tagToMainCategory = {
    "Arremesso" : "Arremesso",
    "Arremesso de 3 Pontos" : "Arremesso",
    "Arremesso em Movimento" : "Arremesso",
    "Arremesso sob Pressão" : "Arremesso",
    "Fade-Away" : "Arremesso",
    "Lance-livre" : "Arremesso",
    "Mid-Range" : "Arremesso",
    "Step-Back" : "Arremesso",

    "Atleticismo" : "Atleticismo",
    "Explosão" : "Atleticismo",
    "Coordenação Motora" : "Atleticismo",
    "Impulsão" : "Atleticismo",
    "Mudança de Direção" : "Atleticismo",
    "Velocidade" : "Atleticismo",

    "Controle de Bola" : "Controle de Bola",
    "Behind The Back" : "Controle de Bola",
    "Mudança de Ritmo" : "Controle de Bola",
    "Crossover" : "Controle de Bola",
    "Drible de Proteção" : "Controle de Bola",
    "Entre as Pernas" : "Controle de Bola",
    "In and Out" : "Controle de Bola",
    "Spin Move" : "Controle de Bola",
    "Drible": "Controle de Bola",

    "Defesa" : "Defesa",
    "Box Out" : "Defesa",
    "Contestação de Arremesso" : "Defesa",
    "Defesa de Garrafão" : "Defesa",
    "Defesa Individual" : "Defesa",
    "Marcação Perímetro" : "Defesa",
    "Roubo de Bola" : "Defesa",

    "Finalização" : "Finalização",
    "Bandeja Simples" : "Finalização",
    "Enterrada" : "Finalização",
    "Euro Step" : "Finalização",
    "Finger Roll" : "Finalização",
    "Floater" : "Finalização",
    "Layup em Velocidade" : "Finalização",
    "Reverse Layup" : "Finalização",

    "QI de Basquete": "QI de Basquete",
    "Controle de Jogo" : "QI de Basquete",
    "Jogo de Transição" : "QI de Basquete",
    "Tomade de Decisão" : "QI de Basquete",
  };

  /// Recebe uma tag e retorna a categoria principal
  static String mapTagToMain(String tag) {
    return tagToMainCategory[tag] ?? fallback;
  }

  /// All unique main categories in display order.
  static const List<String> mainCategories = [
    'Arremesso',
    'Atleticismo',
    'Controle de Bola',
    'Defesa',
    'Finalização',
    'QI de Basquete',
  ];

  /// Returns all sub-tags that belong to [main] (excluding the main tag itself).
  static List<String> subTagsFor(String main) {
    return tagToMainCategory.entries
        .where((e) => e.value == main && e.key != main)
        .map((e) => e.key)
        .toList();
  }

  /// Recebe várias tags e retorna as categorias principais únicas
  static List<String> mapTagsToMainCategories(List<String> tags) {
    final set = <String>{};

    for (final tag in tags) {
      final main = mapTagToMain(tag);
      set.add(main);
    }

    return set.toList();
  }
}
