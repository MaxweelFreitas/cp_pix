class Pix {
  static bool isValidCPF(String cpf) {
    // Remove caracteres não numéricos
    cpf = cpf.replaceAll(RegExp(r'\D'), '');

    // Verifica se o CPF tem 11 dígitos ou se todos os dígitos são iguais
    if (cpf.length != 11 || RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
      return false;
    }

    // Calcula o primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    int firstVerifier = (sum * 10) % 11;
    if (firstVerifier == 10) firstVerifier = 0;

    // Verifica o primeiro dígito verificador
    if (firstVerifier != int.parse(cpf[9])) {
      return false;
    }

    // Calcula o segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    int secondVerifier = (sum * 10) % 11;
    if (secondVerifier == 10) secondVerifier = 0;

    // Verifica o segundo dígito verificador
    if (secondVerifier != int.parse(cpf[10])) {
      return false;
    }

    return true;
  }

  /// Valida um CNPJ.
  ///
  /// Recebe uma string contendo o CNPJ e retorna `true` se o CNPJ for válido,
  /// e `false` caso contrário.
  ///
  /// O CNPJ é considerado válido se tiver 14 dígitos e os dígitos verificadores
  /// calculados coincidirem com os fornecidos. O formato do CNPJ deve ser apenas
  /// números (os caracteres não numéricos são removidos automaticamente).
  ///
  /// Exemplo de uso:
  /// ```dart
  /// bool isValid = isValidCNPJ('12.345.678/0001-95'); // true ou false
  /// ```
  ///
  /// [cnpj] é uma string contendo o CNPJ para validação.
  static bool isValidCNPJ(String cnpj) {
    // Remove caracteres não numéricos
    cnpj = cnpj.replaceAll(RegExp(r'\D'), '');

    // Verifica se o CNPJ tem 14 dígitos ou se todos os dígitos são iguais
    if (cnpj.length != 14 || RegExp(r'^(\d)\1*$').hasMatch(cnpj)) {
      return false;
    }

    // Função auxiliar para calcular o dígito verificador
    int calculateVerifier(List<int> digits, int length) {
      int sum = 0;
      int weight = length;
      for (int i = 0; i < length; i++) {
        sum += digits[i] * weight--;
        if (weight < 2) weight = 9;
      }
      int remainder = sum % 11;
      return remainder < 2 ? 0 : 11 - remainder;
    }

    // Converte os dígitos em uma lista
    List<int> digits = cnpj.split('').map(int.parse).toList();

    // Calcula o primeiro dígito verificador
    int firstVerifier = calculateVerifier(digits.sublist(0, 12), 12);
    if (firstVerifier != digits[12]) {
      return false;
    }

    // Calcula o segundo dígito verificador
    int secondVerifier = calculateVerifier(digits.sublist(0, 13), 13);
    if (secondVerifier != digits[13]) {
      return false;
    }

    return true;
  }

  /// Valida um número de telefone para ser usado como chave Pix.
  ///
  /// Este método verifica se o número fornecido segue os padrões de
  /// um número de telefone válido para registro como chave Pix.
  /// Ele aceita números nos formatos internacional e nacional.
  ///
  /// Formatos aceitos:
  /// - Internacional: +55 seguido de 10-11 dígitos.
  ///   - Exemplo válido: `+5511998765432`
  /// - Nacional: Código de área (DDD) seguido de 8-9 dígitos.
  ///   - Exemplo válido: `11998765432`
  ///
  /// Retorna:
  /// - `true` se o número for válido.
  /// - `false` se o número for inválido.
  ///
  /// Exemplos:
  /// ```dart
  /// bool isValid1 = isValidPixPhoneNumber('+5511998765432'); // true
  /// bool isValid2 = isValidPixPhoneNumber('11998765432'); // true
  /// bool isValid3 = isValidPixPhoneNumber('011998765432'); // false
  /// ```
  static bool isValidPixPhoneNumber(String phoneNumber) {
    // Regex para formato internacional (+55 seguido de 10-11 dígitos)
    final regexInternational = RegExp(r'^\+55\d{10,11}$');

    // Regex para formato nacional (sem o +55, mas com DDD e 8-9 dígitos)
    final regexNational = RegExp(r'^\d{10,11}$');

    // Verificação de comprimento
    if (phoneNumber.length < 10 || phoneNumber.length > 13) {
      return false;
    }

    // Verificação do formato internacional
    if (phoneNumber.startsWith('+55')) {
      if (!regexInternational.hasMatch(phoneNumber)) {
        return false;
      }
    }
    // Verificação do formato nacional
    else if (regexNational.hasMatch(phoneNumber)) {
      // Validação adicional para o código de área (DDD)
      final ddd = phoneNumber.substring(0, 2);
      final phoneDigits = phoneNumber.substring(2);
      if (ddd.startsWith('0') ||
          phoneDigits.length < 8 ||
          phoneDigits.length > 9) {
        return false;
      }
    }
    // Caso nenhum formato seja válido
    else {
      return false;
    }

    // Se todas as verificações forem passadas
    return true;
  }

  /// Verifica se um endereço de email é válido conforme o padrão RFC 5322.
  ///
  /// Recebe uma string contendo um endereço de email e retorna `true` se o email
  /// for considerado válido conforme o padrão RFC 5322, e `false` caso contrário.
  ///
  /// A validação é feita utilizando uma expressão regular que cobre o padrão RFC 5322
  /// para endereços de email, incluindo vários casos específicos e possíveis variantes.
  ///
  /// Exemplo de uso:
  /// ```dart
  /// bool isValid = isValidEmail('example@example.com'); // true ou false
  /// ```
  ///
  /// [email] é uma string contendo o endereço de email para validação.
  static bool isValidEmail(String email) {
    // Parte da expressão regular para a parte local (local part) do email
    String localPart = r"[a-zA-Z0-9!#$%&\'*+/=?^_`{|}~-]+";
    String localPartSub = r"(?:\.[a-zA-Z0-9!#$%&\'*+/=?^_`{|}~-]+)*";

    // Parte da expressão regular para a parte local do email entre aspas
    String quotedLocalPart =
        r'"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*"';

    // Parte da expressão regular para o domínio do email
    String domainName = r'[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?';
    String domain = r'(?:\.' + domainName + r')+';

    // Parte da expressão regular para o endereço IP ou domínio literal
    String ipAddress =
        r'(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)';
    String domainLiteral = r'\[(?:(?:' +
        ipAddress +
        r'|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\\])';

    // Expressão regular final combinando a parte local e o domínio
    String emailRegex = r'^(' +
        localPart +
        localPartSub +
        r'|' +
        quotedLocalPart +
        r')@(' +
        domain +
        r'|' +
        domainLiteral +
        r')$';

    // Criação da RegExp com a expressão regular e configuração para não diferenciação de maiúsculas e minúsculas
    RegExp emailPattern = RegExp(
      emailRegex,
      caseSensitive: false,
    );

    // Verifica se o email corresponde ao padrão RFC 5322
    return emailPattern.hasMatch(email);
  }

  /// Valida uma chave aleatória do Pix.
  ///
  /// A chave aleatória do Pix é uma sequência alfanumérica gerada automaticamente,
  /// que pode conter letras maiúsculas, minúsculas, números e alguns caracteres especiais.
  ///
  /// O padrão exato da chave aleatória é:
  /// - Comprimento: até 36 caracteres.
  /// - Caracteres permitidos:
  ///     - letras maiúsculas (A-Z)
  ///     - letras minúsculas (a-z)
  ///     - Números (0-9)
  ///     - Hífens (-)
  ///     - Underlines (_).
  ///
  /// Esta função verifica se o código fornecido atende a esses critérios.
  ///
  /// Exemplo de uso:
  /// ```dart
  /// print(isValidRandomPIXKey('A1b2C3d4E5f6G7h8I9J0kL')); // true
  /// print(isValidRandomPIXKey('8q7tX9uC4rS-3n2jZ'));     // true
  /// print(isValidRandomPIXKey('MNBV98765-asdfgh12345')); // true
  /// print(isValidRandomPIXKey('InvalidKey123!@#'));      // false (contém caracteres inválidos)
  /// print(isValidRandomPIXKey('TooLongPixKey123456789012345678901234567890123456')); // false (muito longa)
  /// ```
  ///
  /// Parâmetros:
  /// - `code`: A chave aleatória a ser validada.
  ///
  /// Retorna:
  /// - `true` se o código estiver no formato correto e tiver até 36 caracteres.
  /// - `false` caso contrário.
  static bool isValidRandomPIXKey(String code) {
    // Define o padrão para a chave Pix aleatória
    final RegExp pattern = RegExp(
      r'^[A-Za-z0-9-_]{1,36}$',
      caseSensitive: false,
    );

    // Verifica se a chave está no formato correto e se tem até 36 caracteres
    return pattern.hasMatch(code) && code.length <= 36;
  }

  /// Valida um código Pix.
  ///
  /// Recebe uma string contendo o código Pix e retorna `true` se o código for
  /// válido, e `false` caso contrário.
  ///
  /// O código Pix é considerado válido se atender aos seguintes critérios:
  ///
  /// 1. O código deve ter pelo menos 40 caracteres (geralmente é bem maior).
  /// 2. Deve começar com o identificador inicial '000201'.
  /// 3. Deve conter o segmento 'BR.GOV.BCB.PIX' (em qualquer combinação de maiúsculas e minúsculas).
  /// 4. Deve terminar com o CRC32, que é um código de verificação de 4 dígitos hexadecimal (formatado como '6304').
  ///
  /// Exemplo de uso:
  /// ```dart
  /// bool isValid = isValidCopyPastPIXCode('000201...BR.GOV.BCB.PIX...6304ABCD'); // true ou false
  /// ```
  ///
  /// [codigo] é uma string contendo o código Pix para validação.
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

  /// Extrai o nome do recebedor de um código Pix.
  ///
  /// Esta função usa uma expressão regular para identificar e extrair o nome do
  /// recebedor de um código Pix. O código Pix deve seguir o padrão do código
  /// de identidade do recebedor que é precedido pelo identificador "59". O nome
  /// do recebedor é extraído do código Pix a partir desse identificador.
  ///
  /// A expressão regular usada é `59(\d{2})(.{2,})60`. O grupo 1 da expressão
  /// regular captura o comprimento do nome do recebedor e o grupo 2 captura o
  /// nome completo do recebedor. O nome do recebedor é retornado com base no
  /// comprimento especificado no grupo 1. Caso o nome não possa ser extraído,
  /// a função retorna `null`.
  ///
  /// Exemplo:
  /// ```dart
  /// String codigoPix = "00020126540014BR5925004054João Silva6009B2F4";
  /// String? nomeRecebedor = getReceiverName(codigoPix);
  /// print(nomeRecebedor); // Saída: João Silva
  /// ```
  ///
  /// Parâmetros:
  /// - `codigoPix`: O código Pix do qual o nome do recebedor deve ser extraído.
  ///
  /// Retorna:
  /// - O nome do recebedor como uma [String] se o nome puder ser extraído;
  ///   caso contrário, retorna `null`.
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
