import 'package:cp_pix/helpers/pix.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CPF ⇒', () {
    test('Should return true when the umber is valid', () {
      List<String> cpfsValidos = [
        "123.456.789-09",
        "987.654.321-00",
        "602.961.730-37",
      ];

      for (var cpf in cpfsValidos) {
        final result = Pix.isValidCPF(cpf);
        expect(result, true);
      }
    });

    test('Should return true when the umber is invalid', () {
      List<String> cpfsInvalidos = [
        "123.456.789-00", // Dígitos verificadores inválidos
        "987.654.321-12", // Dígitos verificadores inválidos
        "111.111.111-11", // Sequência inválida de dígitos repetidos
      ];

      for (var cpf in cpfsInvalidos) {
        final result = Pix.isValidCPF(cpf);
        expect(result, false);
      }
    });
  });

  group('CNPJ ⇒', () {
    test('Should return true when the umber is valid', () {
      List<String> cnpjsValidos = [
        "04.252.011/0001-10",
        "42.498.825/0001-28",
        "24.443.340/0001-55",
      ];

      for (var cnpj in cnpjsValidos) {
        final result = Pix.isValidCNPJ(cnpj);
        expect(result, true);
      }
    });

    test('Should return true when the umber is invalid', () {
      List<String> cnpjsInvalidos = [
        "12.345.678/0001-00", // Dígitos verificadores inválidos
        "98.765.432/0001-12", // Dígitos verificadores inválidos
        "11.111.111/1111-11", // Sequência inválida de dígitos repetidos
      ];

      for (var cnpj in cnpjsInvalidos) {
        final result = Pix.isValidCNPJ(cnpj);

        expect(result, false);
      }
    });
  });

  group('PhoneNumber ⇒', () {
    test('Should return true when receive a valid number', () {
      List<String> validPhoneNumbers = [
        '+5511998765432', // Código do país +55, código de área 11, número válido
        '+5531987654321', // Código do país +55, código de área 31, número válido
        '+5521998765432', // Código do país +55, código de área 21, número válido
        '+5544998765432' // Código do país +55, código de área 44, número válido
      ];

      for (var phoneNumber in validPhoneNumbers) {
        final result = Pix.isValidPhone(phoneNumber);
        expect(result, true);
      }
    });

    test('Should return false when receive an inValid number', () {
      List<String> invalidPhoneNumbers = [
        '+55119987654', // Falta um dígito (deveria ter 13 dígitos no total)
        '+551199876543', // Falta o código do país ou o número está incompleto
        '+5521-998765432', // Formato inválido (contém caracteres não numéricos)
        '+55449987654321', // Número muito longo (deveria ter 13 dígitos no total)
        '+556199876543', // Código de área inválido (não existe)
        '5511998765432', // Falta o código do país
        '+55abc998765432' // Contém caracteres não numéricos
      ];

      for (var phoneNumber in invalidPhoneNumbers) {
        final result = Pix.isValidPhone(phoneNumber);
        expect(result, false);
      }
    });
  });

  group('Email ⇒', () {
    test('Should return true when the email isValid', () {
      List<String> validEmails = [
        'test@example.com',
        'user123@example.com',
        'user.name@example.com',
        'user-name@example.com',
        'user@subdomain.example.com',
        'user@example.co.uk',
        'first.last.middle@example.com',
        'user@sub.subdomain.example.com',
        'user+mailbox@example.com',
        'user_name@example.com',
      ];

      for (var email in validEmails) {
        final mail = Pix.isValidEmail(email);
        expect(mail, true);
      }
    });

    test('Should return false when the email is inValid', () {
      List<String> invalidEmails = [
        'testexample.com', // Faltando o "@"
        'user@.com', // Faltando domínio
        '@example.com', // Faltando parte local
        'user@com', // Dominio inválido
        '.user@example.com', // Começando com um ponto
        'user..name@example.com', // Tendo um ponto consecutivo
        'user!name@example.com', // Caractere especial inválido
        'user name@example.com', // Com espaços
        'user\\name@example.com' // Barra invertida sem escape
      ];
      for (var email in invalidEmails) {
        final mail = Pix.isValidEmail(email);
        expect(mail, false);
      }
    });
  });

  group('RandomKey ⇒', () {
    test('Should return true when the randomKey is valid', () {
      List<String> validRandomPIXKeys = [
        '123e4567e89b12d3a456426614174000', // Ausência total de hífens
        'c8d59ff2-8176-4f2e-bbbb-000e4f752e3f',
        'a1b2c3d4-e5f6-7g8h-9i0j-k1l2m3n4o5p6',
        '123e4567-e89b-12d3-a456-426614174000',
        '987f6543-21ed-0ba9-8765-4321fedcba98',
      ];

      for (var key in validRandomPIXKeys) {
        final result = Pix.isValidRandomPIXKey(key);
        expect(result, true);
      }
    });

    test('Should return false when the randomKey is invalid', () {
      List<String> invalidRandomPIXKeys = [
        'g123e4567-e89b-12d3-a456-426614174000', // Contém caracteres inválidos ('g')
        '123e-4567-e89b-12d3-a456-426614174000-', // Hífen extra no final
        '123e4567e89b-12d3-a456-42661417400033345', // Comprimento incorreto
      ];

      for (var key in invalidRandomPIXKeys) {
        final result = Pix.isValidRandomPIXKey(key);
        expect(result, false);
      }
    });
  });

  group('CopyPast ⇒', () {
    test('Should return true when the key follow the rules for copyPastPIX',
        () {
      List<String> validPixKeys = [
        '00020101021226990014br.gov.bcb.pix2577pix.bpp.com.br/23114447/qrs2/v2/cobv/02eBSTsgvwSp1Ud17RP4UOgYx4Ao3TF7g4c50uxW520400005303986540590.005802BR5920E F DE BRITO BARBOSA6006Sobral62070503***630404A0',
      ];

      for (var key in validPixKeys) {
        final result = Pix.isValidCopyPast(key);
        expect(result, true);
      }
    });

    test(
        'Should return false when the key doesn\'t follow the rules for copyPastPIX',
        () {
      List<String> invalidPixKeys = [
        '00020101021226990014br.gov.bcb.pix2577pix.bpp.com.br/23114447/qrs2/v2/cobv/02eBSTsgvwSp1Ud17RP4UOgYx4Ao3TF7g4c50uxW520400005303986540590.005802BR5920E F DE BRITO BARBOSA6006Sobral62070503***',
        '000201010212269900142577pix.bpp.com.br/23114447/qrs2/v2/cobv/02eBSTsgvwSp1Ud17RP4UOgYx4Ao3TF7g4c50uxW520400005303986540590.005802BR5920E F DE BRITO BARBOSA6006Sobral62070503***',
      ];
      for (var key in invalidPixKeys) {
        final result = Pix.isValidCopyPast(key);
        expect(result, false);
      }
    });
  });

  group('ReceiverName ⇒', () {
    test('Should return true when the code has the receiverName', () {
      List<String> validPixKeys = [
        '00020101021226990014br.gov.bcb.pix2577pix.bpp.com.br/23114447/qrs2/v2/cobv/02eBSTsgvwSp1Ud17RP4UOgYx4Ao3TF7g4c50uxW520400005303986540590.005802BR5920E F DE BRITO BARBOSA6006Sobral62070503***630404A0',
      ];

      for (var key in validPixKeys) {
        final result = Pix.getReceiverName(key);
        const receiverName = 'E F DE BRITO BARBOSA';
        expect(result, receiverName);
      }
    });

    test('Should return null when the code hasn\'t the receiverName', () {
      List<String> validPixKeys = [
        '00020101021226990014br.gov.bcb.pix2577pix.bpp.com.br/23114447/qrs2/v2/cobv/02eBSTsgvwSp1Ud17RP4UOgYx4Ao3TF7g4c50uxW520400005303986540590.005802BRSobral62070503***630404A0',
      ];

      for (var key in validPixKeys) {
        final result = Pix.getReceiverName(key);

        expect(result, null);
      }
    });
  });
}
