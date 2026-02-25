import 'package:exceltodb/grupo_helper.dart';
import 'package:exceltodb/produto_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    if (dbPath == null) {
      throw Exception('O caminho do banco ainda não foi definido.');
    }

    _database = await _initDatabase();
    return _database!;
  }

  String? dbPath;

  Future<void> initGlobal(String path) async {
    dbPath = path;

    _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      dbPath!,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<int> createCodigoProduto() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT MAX(codigo_produto) as max_num FROM produto',
    );
    int proximoNumero = (result.first['max_num'] as int? ?? 0) + 1;

    return proximoNumero;
  }

  Future<String> searchCodigoGrupo(String desc) async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT id_prod_grupo FROM prod_grupo WHERE descricao = ?',
      [desc],
    );

    if (result.isNotEmpty) {
      return result.first['id_prod_grupo'].toString();
    } else {
      final id = await createGrupo(desc);
      return id['id_prod_grupo'].toString();
    }
  }

  Future<String> searchCodigoSubGrupo(String desc) async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT id_prod_subgrupo FROM prod_subgrupo WHERE descricao = ?',
      [desc],
    );

    if (result.isNotEmpty) {
      return result.first['id_prod_subgrupo'].toString();
    } else {
      final id = await createGrupo(desc);
      return id['id_prod_subgrupo'].toString();
    }
  }

  Future<String> searchCodigoUnidade(String desc) async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT id_prod_unidade FROM prod_unidade WHERE descricao = ?',
      [desc],
    );

    if (result.isNotEmpty) {
      return result.first['id_prod_unidade'].toString();
    }
    return '';
  }

  Future<Map<String, dynamic>> createGrupo(String desc) async {
    final db = await database;
    final grupo = await GrupoHelper.create(descricao: desc);
    final idgp = grupo.id_prod_grupo;
    await db.insert('prod_grupo', grupo.toMap());

    final subgrupo = await SubGrupoHelper.create(descricao: desc);
    final idsubgp = subgrupo.id_prod_subgrupo;
    await db.insert('prod_subgrupo', subgrupo.toMap());

    return {'id_prod_subgrupo': idsubgp, 'id_prod_grupo': idgp};
  }

  Future<void> createProduto({
    required String desc,
    required double precoVenda,
    String? descricaoGp,
    double? precoCusto,
    String? ncm,
    String? cest,
    double? qtdEstoque,
  }) async {
    final db = await database;

    final produto = await ProdutoHelper.create(
      precoCusto: precoCusto,
      descricao: desc,
      precoVenda: precoVenda,
      descricaoGp: descricaoGp,
      ncm: ncm,
      cest: cest,
      qtdEstoque: qtdEstoque,
    );

    await db.insert('produto', produto.toMap());
  }

  Future<void> deleteProdutos(void Function(String) logCallback) async {
    final db = await database;
    await db.transaction((txn) async {
      try {
        await txn.execute('PRAGMA foreign_keys = OFF');
        logCallback("Deletando produtos...");
        await txn.delete('produto');
        logCallback("Produtos deletados com sucesso!");

        logCallback("Deletando subgrupos...");
        await txn.delete('prod_subgrupo');
        logCallback("Subgrupos deletados com sucesso!");

        logCallback("Deletando grupos...");
        await txn.delete('prod_grupo');
        logCallback("Grupos deletados com sucesso!");
        await txn.execute('PRAGMA foreign_keys = ON');
      } catch (e, st) {
        logCallback("Erro ao deletar: $e");
        logCallback("Stacktrace: $st");
        rethrow; // opcional, se quiser propagar o erro
      }
    });
  }
}
