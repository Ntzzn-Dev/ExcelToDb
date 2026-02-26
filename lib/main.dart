import 'package:exceltodb/database_helper.dart';
import 'package:exceltodb/excel_helper.dart';
import 'package:exceltodb/themes.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Musync',
      theme: darktheme(),
      home: MyHomePage(title: 'Excel to db'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> logs = [];
  String dbName = "Selecionar arquivo .db";
  String excelName = "Selecionar arquivo .xlsx";

  final btnStyle = ElevatedButton.styleFrom(
    backgroundColor: baseFundoDark,
    padding: const EdgeInsets.symmetric(vertical: 36),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  void addLog(String message) {
    setState(() {
      logs.add(message);
    });
  }

  Future<void> pickDbFile() async {
    final typeGroup = XTypeGroup(label: 'db', extensions: ['db']);

    final file = await openFile(acceptedTypeGroups: [typeGroup]);

    if (file == null) return;

    setState(() {
      dbName = file.name;
    });

    DatabaseHelper.instance.initGlobal(file.path);
  }

  Future<void> pickExcelFile() async {
    final typeGroup = XTypeGroup(label: 'xlsx', extensions: ['xlsx', 'xls']);

    final file = await openFile(acceptedTypeGroups: [typeGroup]);

    if (file == null) return;

    setState(() {
      excelName = file.name;
    });

    ExcelHelper.instance.excelPath = file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Painel de Controle Excel2DB")),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Logs de Execução",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        return Text(
                          logs[index],
                          style: const TextStyle(
                            fontFamily: "Courier",
                            fontSize: 18,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      addLog("Selecionando arquivo .db...");
                      await pickDbFile();
                      addLog("Arquivo selecionado! $dbName");
                      addLog("-=+=-");
                    },
                    style: btnStyle,
                    child: Text(dbName),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      addLog("Selecionando arquivo .xlsx...");
                      await pickExcelFile();
                      addLog("Arquivo selecionado! $excelName");
                      addLog("-=+=-");
                    },
                    style: btnStyle,
                    child: Text(excelName),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () async {
                      addLog("Iniciando inserção de dados...");
                      await ExcelHelper.instance.readExcelFile(addLog);
                      addLog("Inserção finalizada com sucesso!");
                      addLog("-=+=-");
                    },
                    icon: const Icon(Icons.play_arrow, size: 24),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "Iniciar inserção de dados",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: btnStyle,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      addLog("Limpando produtos...");
                      await DatabaseHelper.instance.deleteProdutos(addLog);
                      addLog("Produtos removidos com sucesso!");
                      addLog("-=+=-");
                    },
                    icon: const Icon(Icons.delete, size: 24),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "Limpar Produtos",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: btnStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
