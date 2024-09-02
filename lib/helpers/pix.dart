import 'dart:math';

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
  /// Ele aceita números nos formatos internacional e nacional,
  /// com ou sem separadores.
  ///
  /// Formatos aceitos:
  /// - Internacional: +55 seguido de 11 dígitos, começando com 9.
  ///   - Exemplo válido: `+5511998765432`, `558899744051`
  /// - Nacional: Código de área (DDD) seguido de 9 dígitos, começando com 9.
  ///   - Exemplo válido: `11998765432`, `8899744051`
  /// - Formatos com separadores:
  ///   - Internacional: `+55(88)99744-051`
  ///   - Nacional: `(88)99744-051`
  ///
  /// Retorna:
  /// - `true` se o número for válido.
  /// - `false` se o número for inválido.
  ///
  /// Exemplos:
  /// ```dart
  /// bool isValid1 = isValidPhone('+5511998765432'); // true
  /// bool isValid2 = isValidPhone('11998765432'); // true
  /// bool isValid3 = isValidPhone('(88)99744-051'); // true
  /// bool isValid4 = isValidPhone('558899744051'); // true
  /// bool isValid5 = isValidPhone('1198765432'); // false
  /// bool isValid6 = isValidPhone('+553199876543'); // false
  /// ```
  static bool isValidPhone(String phoneNumber) {
    // Expressão regular para validar números de telefone com e sem código de país
    final RegExp phoneRegex = RegExp(
      r'^(\+55)?(?:\s*\(?\d{2}\)?\s*)?\d{4,5}-?\d{4}$',
      caseSensitive: false,
      dotAll: true,
    );

    // Expressão regular para validar números de telefone como chaves Pix
    final RegExp pixKeyRegex = RegExp(
      r'^(\+55)?(?:\s*\(?\d{2}\)?\s*)?\d{9}$',
      caseSensitive: false,
      dotAll: true,
    );

    // Remove caracteres não numéricos (exceto +)
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d\+]'), '');

    // Verifica se o número limpo tem exatamente 13 dígitos
    bool hasExact13Digits = cleanedNumber.substring(1).length == 13;

    // Verifica se o número limpo corresponde ao formato esperado para telefone
    bool isPhoneValid = phoneRegex.hasMatch(phoneNumber);

    // Verifica se o número limpo pode ser uma chave Pix
    bool isPixKeyValid = pixKeyRegex.hasMatch(cleanedNumber);

    // Retorna true apenas se o número for tanto um telefone válido quanto uma chave Pix válida e tiver exatamente 13 dígitos
    return hasExact13Digits && isPhoneValid && isPixKeyValid;
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
    // Verifica se a chave tem exatamente 32 caracteres
    if (code.length != 32) {
      return false;
    }

    // Verifica se a chave contém apenas letras e números
    final RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');
    return regex.hasMatch(code);
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

  /// Gera uma chave aleatória para o Pix com 32 caracteres alfanuméricos.
  ///
  /// A chave gerada é composta por letras maiúsculas, minúsculas e números, e
  /// possui exatamente 32 caracteres. Esta função utiliza o gerador de números
  /// aleatórios da biblioteca `dart:math` para criar a chave.
  ///
  /// Exemplo de uso:
  /// ```dart
  /// String key = genRandomKey();
  /// print(key); // Exemplo de saída: '4T9sDkJ8Lmn4UVZt0Fh1R2Wxj3pGZyQ5cP6I7N8O9A'
  /// ```
  ///
  /// Retorna:
  /// Uma string contendo a chave aleatória gerada.
  static String genRandomKey() {
    const int keyLength = 32;
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random rng = Random();

    // Gera a chave aleatória
    final StringBuffer key = StringBuffer();
    for (int i = 0; i < keyLength; i++) {
      final int index = rng.nextInt(chars.length);
      key.write(chars[index]);
    }

    return key.toString();
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
