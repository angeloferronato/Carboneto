class PositionMapper {
  final map = {
    'armador': 'pg',
    'ala': 'sf',
    'ala-armador': 'sg',
    'pivô': 'c',
    'ala-pivô': 'pf'
  };

  String toAbreviatte(String position) {
    return map[position] ?? '';
  }
}