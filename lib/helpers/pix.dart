class Pix {
  static bool isValidCopyPastPIXCode(String codigo) {
    // O código Pix deve ter pelo menos 40 caracteres (geralmente é bem maior).
    if (codigo.length < 40) return false;

    // Verifica se contém o identificador inicial do Pix (000201)
    if (!codigo.startsWith('000201')) return false;

    // Verifica se contém o segmento BR.GOV.BCB.PIX que identifica a chave Pix
    if (!codigo.toLowerCase().contains('br.gov.bcb.pix')) return false;

    // Verifica se contém o CRC32 que é o código de verificação de 4 dígitos no final (formatado como '6304')
    RegExp crcPattern = RegExp(r'6304[0-9A-Fa-f]{4}$');
    if (!crcPattern.hasMatch(codigo)) return false;

    // Se passou por todas as verificações básicas, consideramos o código válido.
    return true;
  }

  static String? getReceiverName(String codigoPix) {
    // Regex para capturar o nome do recebedor após o identificador 59.
    RegExp nomePattern = RegExp(r'59(\d{2})(.{2,})60');

    // Verifica se há uma correspondência no código Pix.
    RegExpMatch? match = nomePattern.firstMatch(codigoPix);

    if (match != null) {
      // O grupo 1 contém o comprimento do nome.
      int tamanhoNome = int.parse(match.group(1)!);

      // O grupo 2 contém o nome do recebedor.
      String nomeRecebedor = match.group(2)!.substring(0, tamanhoNome);

      return nomeRecebedor;
    }

    // Retorna null se o nome não puder ser extraído.
    return null;
  }
}
