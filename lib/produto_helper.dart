// ignore_for_file: unused_element_parameter

import 'package:exceltodb/database_helper.dart';
import 'package:uuid/uuid.dart';

String createUUID() {
  //primary key
  var uuid = Uuid();
  return uuid.v1();
}

String createData() {
  return DateTime.now().toIso8601String();
}

double createMargem(double precoVenda, double precoCusto) {
  if (precoCusto == 0) return 0;
  return (precoVenda - precoCusto) / precoCusto * 100;
}

class ProdutoHelper {
  /* Valores aparentemente padrões */
  final String idProduto; // text
  final String dataHoraCriado; // text
  final String? dataHoraDeletado; // text
  final String? dataHoraUltimaAlteracao; // text
  final String descricao; //text
  final String idProdUnidade; // text FOREIGN KEY
  final String idProdSubgrupo; // text FOREIGN KEY
  final String idProdGrupo; // text FOREIGN KEY
  final double precoCusto; // real
  final double outrosCustos; // real
  final double margem; // double
  final double producaoPropria; // inteiro
  final double produtoFinanceiro; // inteiro
  final double precoVenda; // real
  final double? qtdEstoque; // double
  final double qtdEstoqueMinimo; // double
  final String? cstIcms; // text
  final double pRedBcEfetIcms; // real
  final double pAliqEfetIcms; // real
  final String? cstPisCofins; // text
  final String? ncm; // text
  final String? exTipi; // text
  final String? cest; // text
  final int origemMercadoria; // inteiro
  final int codigoProduto; // inteiro autoincrement
  final int? codigoProdutoBalancaEtiquetadora; // inteiro
  final int codigoProdutoBalancaEtiquetadoraHabilitado; // inteiro
  final int vendidoNoIfood; // inteiro
  final String? idProdutoIfood; // text
  final int vendidoNoCatalogo; // inteiro
  final int exibidoNoMenuDigital; // inteiro
  final String descricaoDetalhada; // text
  final int? limiteSabores; // inteiro
  final int? formaCalculoMultissabor; // inteiro
  final int tipoProdutoComposicao; // inteiro
  final String? idConfigPontoImpressao; // text
  final String? ingredientes; // text
  final String? modoPreparo; // text

  // Construtor privado
  ProdutoHelper._internal({
    required this.idProduto,
    required this.dataHoraCriado,
    required this.descricao,
    required this.idProdUnidade,
    required this.precoCusto,
    required this.precoVenda,
    required this.qtdEstoque,
    required this.margem,
    required this.codigoProduto,
    this.dataHoraDeletado,
    this.dataHoraUltimaAlteracao,
    this.idProdSubgrupo = '',
    this.idProdGrupo = '',
    this.outrosCustos = 0,
    this.producaoPropria = 0,
    this.produtoFinanceiro = 0,
    this.qtdEstoqueMinimo = 0,
    this.cstIcms,
    this.pRedBcEfetIcms = 0,
    this.pAliqEfetIcms = 0,
    this.cstPisCofins,
    this.ncm,
    this.exTipi,
    this.cest,
    this.origemMercadoria = 0,
    this.codigoProdutoBalancaEtiquetadora,
    this.codigoProdutoBalancaEtiquetadoraHabilitado = 0,
    this.vendidoNoIfood = 0,
    this.idProdutoIfood,
    this.vendidoNoCatalogo = 0,
    this.exibidoNoMenuDigital = 0,
    this.descricaoDetalhada = '',
    this.limiteSabores,
    this.formaCalculoMultissabor,
    this.tipoProdutoComposicao = 1,
    this.idConfigPontoImpressao,
    this.ingredientes,
    this.modoPreparo,
  });

  static Future<ProdutoHelper> create({
    required String descricao,
    required double precoVenda,
    String? descricaoGp,
    String? descricaoUn,
    double? precoCusto,
    double? qtdEstoque,
    String? ncm,
    String? cest,
  }) async {
    double precoC = precoCusto ?? 0;
    final double margemCalculada = createMargem(precoVenda, precoC);
    final int codigoProduto = await DatabaseHelper.instance
        .createCodigoProduto();

    final idProdGrupo = await DatabaseHelper.instance.searchCodigoGrupo(
      descricaoGp ?? 'geral',
    );
    final idProdSubGrupo = await DatabaseHelper.instance.searchCodigoSubGrupo(
      descricaoGp ?? 'geral',
    );
    final idProdUnidade = await DatabaseHelper.instance.searchCodigoUnidade(
      descricaoUn ?? 'UN',
    );

    return ProdutoHelper._internal(
      idProduto: createUUID(),
      dataHoraCriado: createData(),
      descricao: descricao,
      idProdUnidade: idProdUnidade,
      idProdGrupo: idProdGrupo,
      idProdSubgrupo: idProdSubGrupo,
      precoCusto: precoC,
      precoVenda: precoVenda,
      qtdEstoque: qtdEstoque,
      margem: margemCalculada,
      codigoProduto: codigoProduto,
      ncm: ncm,
      cest: cest,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_produto': idProduto,
      'data_hora_criado': dataHoraCriado,
      'data_hora_deletado': dataHoraDeletado,
      'data_hora_ultima_alteracao': dataHoraUltimaAlteracao,
      'descricao': descricao,
      'id_prod_unidade': idProdUnidade,
      'id_prod_subgrupo': idProdSubgrupo,
      'id_prod_grupo': idProdGrupo,
      'preco_custo': precoCusto,
      'outros_custos': outrosCustos,
      'margem': margem,
      'producao_propria': producaoPropria,
      'produto_financeiro': produtoFinanceiro,
      'preco_venda': precoVenda,
      'qtd_estoque': qtdEstoque,
      'qtd_estoque_minimo': qtdEstoqueMinimo,
      'cst_icms': cstIcms,
      'p_red_bc_efet_icms': pRedBcEfetIcms,
      'p_aliq_efet_icms': pAliqEfetIcms,
      'cst_pis_cofins': cstPisCofins,
      'ncm': ncm,
      'ex_tipi': exTipi,
      'cest': cest,
      'origem_mercadoria': origemMercadoria,
      'codigo_produto': codigoProduto,
      'codigo_produto_balanca_etiquetadora': codigoProdutoBalancaEtiquetadora,
      'codigo_produto_balanca_etiquetadora_habilitado':
          codigoProdutoBalancaEtiquetadoraHabilitado,
      'vendido_no_ifood': vendidoNoIfood,
      'id_produto_ifood': idProdutoIfood,
      'vendido_no_catalogo': vendidoNoCatalogo,
      'exibido_no_menu_digital': exibidoNoMenuDigital,
      'descricao_detalhada': descricaoDetalhada,
      'limite_sabores': limiteSabores,
      'forma_calculo_multissabor': formaCalculoMultissabor,
      'tipo_produto_composicao': tipoProdutoComposicao,
      'id_config_ponto_impressao': idConfigPontoImpressao,
      'ingredientes': ingredientes,
      'modo_preparo': modoPreparo,
    };
  }
}
