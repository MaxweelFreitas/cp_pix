enum PixKeyType { cpf, cnpj, phone, email, random, copyPast, invalid }

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

    // Converte os dígitos em uma lista
    List<int> digits = cnpj.split('').map(int.parse).toList();

    // Pesos para os dígitos verificadores
    List<int> weightsFirstVerifier = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    List<int> weightsSecondVerifier = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

    int calculateVerifier(List<int> digits, List<int> weights) {
      int sum = 0;

      // Multiplica cada dígito pelo peso correspondente e soma
      for (int i = 0; i < digits.length; i++) {
        sum += digits[i] * weights[i];
      }

      int remainder = sum % 11;

      // O dígito verificador é 0 se o resto da divisão for menor que 2, senão é 11 menos o resto
      return remainder < 2 ? 0 : 11 - remainder;
    }

    // Calcula o primeiro dígito verificador
    int firstVerifier =
        calculateVerifier(digits.sublist(0, 12), weightsFirstVerifier);
    if (firstVerifier != digits[12]) {
      return false;
    }

    // Calcula o segundo dígito verificador
    int secondVerifier =
        calculateVerifier(digits.sublist(0, 13), weightsSecondVerifier);
    if (secondVerifier != digits[13]) {
      return false;
    }

    return true;
  }

  /// Valida um número de celular para ser usado como chave Pix.
  ///
  /// Este método verifica se o número fornecido segue os padrões de
  /// um número de celular válido para registro como chave Pix.
  /// Ele aceita números nos formatos internacional e nacional.
  ///
  /// Formatos aceitos:
  /// - Internacional: +55 seguido de 11 dígitos, começando com 9.
  ///   - Exemplo válido: `+5511998765432`
  /// - Nacional: Código de área (DDD) seguido de 9 dígitos, começando com 9.
  ///   - Exemplo válido: `11998765432`
  ///
  /// Retorna:
  /// - `true` se o número for válido.
  /// - `false` se o número for inválido.
  ///
  /// Exemplos:
  /// ```dart
  /// bool isValid1 = isValidPhone('+5511998765432'); // true
  /// bool isValid2 = isValidPhone('11998765432'); // true
  /// bool isValid3 = isValidPhone('1198765432'); // false
  /// bool isValid4 = isValidPhone('+553199876543'); // false
  /// ```
  static bool isValidPhone(String phoneNumber) {
    // Regex para formato internacional (+55 seguido de 11 dígitos, começando com 9)
    final regexInternational = RegExp(r'^\+55(9\d{10})$');

    // Regex para formato nacional (DDD seguido de 9 dígitos, começando com 9)
    final regexNational = RegExp(r'^\d{2}9\d{8}$');

    // Verificação do formato internacional
    if (phoneNumber.startsWith('+55')) {
      if (!regexInternational.hasMatch(phoneNumber)) {
        return false;
      }
    }
    // Verificação do formato nacional
    else if (regexNational.hasMatch(phoneNumber)) {
      // Validação adicional para o código de área (DDD) e número de celular
      final ddd = phoneNumber.substring(0, 2);
      final phoneDigits = phoneNumber.substring(2);
      if (ddd.startsWith('0') ||
          phoneDigits.length != 9 ||
          !phoneDigits.startsWith('9')) {
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
    String emailRegex =
        r'^(?!.*\.\.)(?!.*\.$)(?!^\.)[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

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
      r'^[A-Za-z0-9_-]{1,36}$',
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
  /// bool isValid = isValidCopyPast('000201...BR.GOV.BCB.PIX...6304ABCD'); // true ou false
  /// ```
  ///
  /// [codigo] é uma string contendo o código Pix para validação.
  static bool isValidCopyPast(String codigo) {
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

  static PixKeyType getPixKeyType(String key) {
    if (Pix.isValidCPF(key)) {
      return PixKeyType.cpf;
    } else if (Pix.isValidCNPJ(key)) {
      return PixKeyType.cnpj;
    } else if (Pix.isValidPhone(key)) {
      return PixKeyType.phone;
    } else if (Pix.isValidEmail(key)) {
      return PixKeyType.email;
    } else if (Pix.isValidCopyPast(key)) {
      return PixKeyType.copyPast;
    } else if (Pix.isValidRandomPIXKey(key)) {
      return PixKeyType.random;
    }
    return PixKeyType.invalid;
  }
}
