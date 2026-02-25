import 'package:exceltodb/database_helper.dart';
import 'package:exceltodb/produto_helper.dart';

class GrupoHelper {
  final String id_prod_grupo; // text
  final String data_hora_criado; // text
  String? data_hora_ultima_alteracao; // text
  String descricao; // text
  String? id_prod_grupo_ifood; // text

  GrupoHelper._internal({
    required this.id_prod_grupo,
    required this.data_hora_criado,
    this.data_hora_ultima_alteracao,
    required this.descricao,
    this.id_prod_grupo_ifood,
  });

  static Future<GrupoHelper> create({required String descricao}) async {
    return GrupoHelper._internal(
      id_prod_grupo: createUUID(),
      data_hora_criado: createData(),
      descricao: descricao,
      data_hora_ultima_alteracao: null,
      id_prod_grupo_ifood: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_prod_grupo': id_prod_grupo,
      'data_hora_criado': data_hora_criado,
      'data_hora_ultima_alteracao': data_hora_ultima_alteracao,
      'descricao': descricao,
      'id_prod_grupo_ifood': id_prod_grupo_ifood,
    };
  }
}

class SubGrupoHelper {
  final String id_prod_subgrupo; // text
  final String data_hora_criado; // text
  String? data_hora_deletado; // text
  String? data_hora_ultima_alteracao; // text
  String id_prod_grupo; // text FOREIGN KEY
  String descricao; // text
  String? id_prod_subgrupo_ifood; // text
  String? id_item_pizza_ifood; // text
  String? id_item_product_pizza_ifood; // text
  String? id_grupo_opcoes_tamanhos_pizza_ifood; // text
  String? id_grupo_opcoes_massas_pizza_ifood; // text
  String? id_grupo_opcoes_bordas_pizza_ifood; // text
  String? id_grupo_opcoes_sabores_pizza_ifood; // text

  // Construtor privado
  SubGrupoHelper._internal({
    required this.id_prod_subgrupo,
    required this.data_hora_criado,
    this.data_hora_deletado,
    this.data_hora_ultima_alteracao,
    required this.id_prod_grupo,
    required this.descricao,
    this.id_prod_subgrupo_ifood,
    this.id_item_pizza_ifood,
    this.id_item_product_pizza_ifood,
    this.id_grupo_opcoes_tamanhos_pizza_ifood,
    this.id_grupo_opcoes_massas_pizza_ifood,
    this.id_grupo_opcoes_bordas_pizza_ifood,
    this.id_grupo_opcoes_sabores_pizza_ifood,
  });

  static Future<SubGrupoHelper> create({required String descricao}) async {
    final idProdGrupo = await DatabaseHelper.instance.searchCodigoGrupo(
      descricao,
    );

    return SubGrupoHelper._internal(
      id_prod_subgrupo: createUUID(),
      data_hora_criado: createData(),
      id_prod_grupo: idProdGrupo,
      descricao: descricao,
      data_hora_deletado: null,
      data_hora_ultima_alteracao: null,
      id_prod_subgrupo_ifood: null,
      id_item_pizza_ifood: null,
      id_item_product_pizza_ifood: null,
      id_grupo_opcoes_tamanhos_pizza_ifood: null,
      id_grupo_opcoes_massas_pizza_ifood: null,
      id_grupo_opcoes_bordas_pizza_ifood: null,
      id_grupo_opcoes_sabores_pizza_ifood: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_prod_subgrupo': id_prod_subgrupo,
      'data_hora_criado': data_hora_criado,
      'data_hora_deletado': data_hora_deletado,
      'data_hora_ultima_alteracao': data_hora_ultima_alteracao,
      'id_prod_grupo': id_prod_grupo,
      'descricao': descricao,
      'id_prod_subgrupo_ifood': id_prod_subgrupo_ifood,
      'id_item_pizza_ifood': id_item_pizza_ifood,
      'id_item_product_pizza_ifood': id_item_product_pizza_ifood,
      'id_grupo_opcoes_tamanhos_pizza_ifood':
          id_grupo_opcoes_tamanhos_pizza_ifood,
      'id_grupo_opcoes_massas_pizza_ifood': id_grupo_opcoes_massas_pizza_ifood,
      'id_grupo_opcoes_bordas_pizza_ifood': id_grupo_opcoes_bordas_pizza_ifood,
      'id_grupo_opcoes_sabores_pizza_ifood':
          id_grupo_opcoes_sabores_pizza_ifood,
    };
  }
}
