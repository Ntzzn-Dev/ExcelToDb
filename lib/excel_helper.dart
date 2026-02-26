import 'dart:io';
import 'package:excel/excel.dart';
import 'package:exceltodb/database_helper.dart';

class ExcelHelper {
  ExcelHelper._internal();
  static final ExcelHelper instance = ExcelHelper._internal();

  String? excelPath;

  Future<void> readExcelFile(void Function(String) logCallback) async {
    if (excelPath == null) return;

    final bytes = File(excelPath!).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    for (var sheetName in excel.tables.keys) {
      logCallback('Planilha: $sheetName');
      final sheet = excel.tables[sheetName];

      if (sheet == null) continue;

      for (var row in sheet.rows.skip(1)) {
        final dados = row.map((cell) => cell?.value).toList();

        if (dados.length < 26) continue;

        final reinsert = await DatabaseHelper.instance.createProduto(
          desc: dados[2].toString(),
          descricaoGp: dados[3].toString(),
          precoCusto: double.tryParse(dados[4]?.toString() ?? '0') ?? 0,
          precoVenda: double.tryParse(dados[6]?.toString() ?? '0') ?? 0,
          ncm: dados[7].toString(),
          cest: dados[9].toString(),
          qtdEstoque: double.tryParse(dados[25]?.toString() ?? '0') ?? 0,
        );
        logCallback(
          '${reinsert ? 'Reativando produto' : 'Inserindo produto'}: ${dados[2]} = R\$ ${(double.tryParse(dados[6]?.toString() ?? '0') ?? 0).toStringAsFixed(2).replaceAll('.', ',')}',
        );
      }
    }

    logCallback('tabela finalizada');
  }
}

//[CODIGO, CODIGO_BARRAS, DESCRICAO, GRUPO, PRECO_CUSTO, MARGEM_LUCRO, PRECO_VENDA, NCM, CFOP, CEST, CBENEF, CSOSN, CST_ICMS, ICMS, CST_PIS, PIS, CST_COFINS, COFINS, CST_IBS_CBS, CLASS_TRIB, CBS, IBS_ESTADUAL, IBS_MUNICIPAL, ESTOQUE_MINIMO, ESTOQUE_MAXIMO, ESTOQUE_ATUAL, UNIDADE, CONTROLA_ESTOQUE, ATIVO, EXIBE_PDV, EXIBE_CARDAPIO, EXIBE_MOBILE, SOLICITA_QUANTIDADE, SOLICITA_COMBINACAO]
