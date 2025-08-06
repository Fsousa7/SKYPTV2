import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../db/database_helper.dart';
import 'dart:convert';

// ============ THEME ==============
final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    primary: Colors.deepPurple.shade600,
    secondary: Colors.blueAccent,
    error: Colors.red.shade400,
    background: const Color(0xFFF7F6FA),
    surface: Colors.white,
    brightness: Brightness.light,
  ),
  fontFamily: 'Inter',
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF7F6FA),
    foregroundColor: Colors.black87,
    elevation: 0.5,
  ),
  scaffoldBackgroundColor: const Color(0xFFF7F6FA),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
);

// ============ ACTION BUTTON ==========
Widget actionButton({
  required String text,
  required Color color,
  required VoidCallback onTap,
  String? tooltip,
  double fontSize = 14,
  EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
}) {
  return Tooltip(
    message: tooltip ?? '',
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: padding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 0,
      ),
      onPressed: onTap,
      child: Text(text, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500)),
    ),
  );
}

// ====================
// MODELOS DE DADOS
// ====================
class Filamento {
  int? id;
  String fabricante;
  int gramas;
  int stockAtual;
  DateTime dataCompra;
  double precoCompra;
  bool danificado;
  String posicaoNota;
  String cor;

  Filamento({
    this.id,
    required this.fabricante,
    required this.gramas,
    required this.stockAtual,
    required this.dataCompra,
    required this.precoCompra,
    required this.danificado,
    required this.posicaoNota,
    required this.cor,
  });

  Map<String, dynamic> toMap() => {
        "fabricante": fabricante,
        "gramas": gramas,
        "stock_atual": stockAtual,
        "data_compra": dataCompra.toIso8601String(),
        "preco_compra": precoCompra,
        "danificado": danificado ? 1 : 0,
        "posicao_nota": posicaoNota,
        "cor": cor,
      };

  factory Filamento.fromMap(Map<String, dynamic> map) => Filamento(
        id: map['id'],
        fabricante: map['fabricante'] ?? '',
        gramas: map['gramas'] ?? 0,
        stockAtual: map['stock_atual'] ?? (map['gramas'] ?? 0),
        dataCompra: DateTime.parse(map['data_compra']),
        precoCompra: (map['preco_compra'] ?? 0).toDouble(),
        danificado: map['danificado'] == 1,
        posicaoNota: map['posicao_nota'] ?? '',
        cor: map['cor'] ?? '',
      );
}

class Acessorio {
  int? id;
  String nome;
  int quantidade;
  double precoCompra;

  Acessorio({
    this.id,
    required this.nome,
    required this.quantidade,
    required this.precoCompra,
  });

  Map<String, dynamic> toMap() => {
        "nome": nome,
        "quantidade": quantidade,
        "preco_compra": precoCompra,
      };

  factory Acessorio.fromMap(Map<String, dynamic> map) => Acessorio(
        id: map['id'],
        nome: map['nome'] ?? '',
        quantidade: map['quantidade'] ?? 0,
        precoCompra: (map['preco_compra'] ?? 0).toDouble(),
      );
}

class Cliente {
  int? id;
  String nome;
  String email;
  String mensagem;
  String objetivo;

  Cliente({
    this.id,
    required this.nome,
    required this.email,
    required this.mensagem,
    required this.objetivo,
  });

  Map<String, dynamic> toMap() => {
        "nome": nome,
        "email": email,
        "mensagem": mensagem,
        "objetivo": objetivo,
      };

  factory Cliente.fromMap(Map<String, dynamic> map) => Cliente(
        id: map['id'],
        nome: map['nome'] ?? '',
        email: map['email'] ?? '',
        mensagem: map['mensagem'] ?? '',
        objetivo: map['objetivo'] ?? '',
      );
}

class FilamentoUsado {
  int filamentoId;
  String cor;
  String fabricante;
  int gramasUsados;
  double custo;

  FilamentoUsado({
    required this.filamentoId,
    required this.cor,
    required this.fabricante,
    required this.gramasUsados,
    required this.custo,
  });

  Map<String, dynamic> toMap() => {
        'filamentoId': filamentoId,
        'cor': cor,
        'fabricante': fabricante,
        'gramasUsados': gramasUsados,
        'custo': custo,
      };

  factory FilamentoUsado.fromMap(Map<String, dynamic> map) => FilamentoUsado(
        filamentoId: map['filamentoId'] ?? 0,
        cor: map['cor'] ?? '',
        fabricante: map['fabricante'] ?? '',
        gramasUsados: map['gramasUsados'] ?? 0,
        custo: (map['custo'] ?? 0.0).toDouble(),
      );
}

class Modelo3D {
  int? id;
  String nome;
  List<FilamentoUsado> filamentosUsados;
  int tempoMinutos;
  String clienteOuPessoal;
  int? clienteId;
  String? clienteNome;
  double energiaKwh;
  double custoEnergia;
  double custoFilamento;
  double custoAcessorios;
  double custoTotal;
  String acessoriosUsados;
  double? precoVenda;
  DateTime? dataCriacao;

  Modelo3D({
    this.id,
    required this.nome,
    required this.filamentosUsados,
    required this.tempoMinutos,
    required this.clienteOuPessoal,
    this.clienteId,
    this.clienteNome,
    required this.energiaKwh,
    required this.custoEnergia,
    required this.custoFilamento,
    required this.custoAcessorios,
    required this.custoTotal,
    required this.acessoriosUsados,
    this.precoVenda,
    this.dataCriacao,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "nome": nome,
        "filamentos_usados": jsonEncode(filamentosUsados.map((f) => f.toMap()).toList()),
        "tempo_minutos": tempoMinutos,
        "cliente_ou_pessoal": clienteOuPessoal,
        "cliente_id": clienteId,
        "cliente_nome": clienteNome,
        "energia_kwh": energiaKwh,
        "custo_energia": custoEnergia,
        "custo_filamento": custoFilamento,
        "custo_acessorios": custoAcessorios,
        "custo_total": custoTotal,
        "acessorios_usados": acessoriosUsados,
        "preco_venda": precoVenda,
        "data_criacao": (dataCriacao ?? DateTime.now()).toIso8601String(),
      };

  factory Modelo3D.fromMap(Map<String, dynamic> map) {
    List<FilamentoUsado> filamentos = [];
    try {
      final String filamentosStr = map['filamentos_usados'] ?? '[]';
      final List<dynamic> filamentosJson = jsonDecode(filamentosStr);
      filamentos = filamentosJson
          .map((e) => FilamentoUsado.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      // Fallback for old data format
      if (map['filamento_id'] != null && map['tipo_filamento'] != null) {
        filamentos = [
          FilamentoUsado(
            filamentoId: map['filamento_id'],
            cor: map['tipo_filamento'] ?? '',
            fabricante: '',
            gramasUsados: map['gramas_utilizadas'] ?? 0,
            custo: (map['custo_filamento'] ?? 0).toDouble(),
          )
        ];
      }
    }

    return Modelo3D(
      id: map['id'],
      nome: map['nome'] ?? '',
      filamentosUsados: filamentos,
      tempoMinutos: map['tempo_minutos'] ?? 0,
      clienteOuPessoal: map['cliente_ou_pessoal'] ?? '',
      clienteId: map['cliente_id'],
      clienteNome: map['cliente_nome'],
      energiaKwh: (map['energia_kwh'] ?? 0).toDouble(),
      custoEnergia: (map['custo_energia'] ?? 0).toDouble(),
      custoFilamento: (map['custo_filamento'] ?? 0).toDouble(),
      custoAcessorios: (map['custo_acessorios'] ?? 0).toDouble(),
      custoTotal: (map['custo_total'] ?? 0).toDouble(),
      acessoriosUsados: map['acessorios_usados'] ?? '',
      precoVenda: map['preco_venda'] != null ? (map['preco_venda'] as num?)?.toDouble() : null,
      dataCriacao: map['data_criacao'] != null ? DateTime.parse(map['data_criacao']) : null,
    );
  }
}

class Gasto {
  int? id;
  String descricao;
  double valor;
  DateTime data;

  Gasto({
    this.id,
    required this.descricao,
    required this.valor,
    required this.data,
  });

  Map<String, dynamic> toMap() => {
        "descricao": descricao,
        "valor": valor,
        "data": data.toIso8601String(),
      };

  factory Gasto.fromMap(Map<String, dynamic> map) => Gasto(
        id: map['id'],
        descricao: map['descricao'] ?? '',
        valor: (map['valor'] ?? 0).toDouble(),
        data: DateTime.parse(map['data']),
      );
}

// ==========================
// BLANKSCREEN PRINCIPAL
// ==========================
class BlankScreen extends StatefulWidget {
  final int userId;
  const BlankScreen({super.key, required this.userId});

  @override
  State<BlankScreen> createState() => _BlankScreenState();
}
class _BlankScreenState extends State<BlankScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Filamento> filamentos = [];
  List<Acessorio> acessorios = [];
  List<Modelo3D> modelos = [];
  List<Cliente> clientes = [];
  List<Gasto> gastos = [];
  double precoKwhUser = 0.25;

  final List<String> _titles = [
    "Gestão de Armazenamento",
    "Gestão de Modelos 3D",
    "Gestão de Clientes",
    "Contabilidade",
    "Definições"
  ];

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    precoKwhUser = await DatabaseHelper.instance.getUserPrecoKwh(widget.userId);
    await Future.wait([
      _loadFilamentos(),
      _loadAcessorios(),
      _loadModelos(),
      _loadClientes(),
      _loadGastos(),
    ]);
  }

  Future<void> updateFilamentoStockAtual(int id, int novoStockAtual) async {
    final db = await DatabaseHelper.instance.database;
    await db.update('filamento', {'stock_atual': novoStockAtual}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> _loadFilamentos() async {
    final data = await DatabaseHelper.instance.getFilamentos(widget.userId);
    setState(() {
      filamentos = data.map((e) => Filamento.fromMap(e)).toList();
    });
  }

  Future<void> _loadAcessorios() async {
    final data = await DatabaseHelper.instance.getAcessorios(widget.userId);
    setState(() {
      acessorios = data.map((e) => Acessorio.fromMap(e)).toList();
    });
  }

  Future<void> _loadModelos() async {
    final data = await DatabaseHelper.instance.getModelos(widget.userId);
    setState(() {
      modelos = data.map((e) => Modelo3D.fromMap(e)).toList();
    });
  }

  Future<void> _loadClientes() async {
    final data = await DatabaseHelper.instance.getClientes(widget.userId);
    setState(() {
      clientes = data.map((e) => Cliente.fromMap(e)).toList();
    });
  }

  Future<void> _loadGastos() async {
    final data = await DatabaseHelper.instance.getGastos(widget.userId);
    setState(() {
      gastos = data.map((e) => Gasto.fromMap(e)).toList();
    });
  }

  void _onSelectMenu(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context);
    });
  }

  Future<void> _editarPrecoKwh(BuildContext ctx) async {
    final controller = TextEditingController(text: precoKwhUser.toStringAsFixed(3));
    final res = await showDialog<double>(
      context: ctx,
      builder: (c) => AlertDialog(
        title: const Text("Preço da Luz (€/kWh)"),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: "Preço por kWh"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text("Cancelar")),
          TextButton(
            onPressed: () {
              final val = double.tryParse(controller.text.replaceAll(',', '.'));
              if (val != null) Navigator.pop(c, val);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
    if (res != null) {
      await DatabaseHelper.instance.updateUserPrecoKwh(widget.userId, res);
      setState(() => precoKwhUser = res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      StoragePage(
        userId: widget.userId,
        filamentos: filamentos,
        acessorios: acessorios,
        onReload: _loadAll,
      ),
      ModelsPage(
        userId: widget.userId,
        modelos: modelos,
        filamentos: filamentos,
        acessorios: acessorios,
        clientes: clientes,
        precoKwhUser: precoKwhUser,
        onReload: _loadAll,
        onAddGasto: (g) async {
          await DatabaseHelper.instance.insertGasto(g.toMap(), widget.userId);
          await _loadGastos();
        },
      ),
      ClientsPage(
        userId: widget.userId,
        clientes: clientes,
        modelos: modelos,
        onReload: _loadAll,
      ),
      AccountingPage(
        modelos: modelos,
        gastos: gastos,
        filamentos: filamentos,
        acessorios: acessorios,
      ),
      SettingsPage(
        precoKwhUser: precoKwhUser,
        onEditarPrecoKwh: () => _editarPrecoKwh(context),
      ),
    ];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titles[_selectedIndex], style: const TextStyle(fontWeight: FontWeight.w500)),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: Drawer(
        elevation: 2,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade700,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SKYPT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sistema de Gestão para Impressão 3D',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Atualizado: 05/08/2025',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            for (int i = 0; i < _titles.length; i++)
              ListTile(
                leading: Icon([
                  Icons.inventory_2,
                  Icons.view_in_ar,
                  Icons.people,
                  Icons.account_balance_wallet,
                  Icons.settings
                ][i], color: _selectedIndex == i ? Colors.deepPurple : Colors.grey[600]),
                title: Text(_titles[i]),
                selected: _selectedIndex == i,
                onTap: () => _onSelectMenu(i),
                selectedTileColor: Colors.deepPurple.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Sobre'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (ctx) => AboutDialog(
                    applicationName: 'Gestão 3D',
                    applicationVersion: '1.0.0',
                    applicationIcon: Icon(
                      Icons.view_in_ar,
                      color: Colors.deepPurple.shade700,
                      size: 42,
                    ),
                    children: const [
                      Text(
                        'Sistema para gestão de impressoras 3D, filamentos, clientes, e contabilidade.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: pages[_selectedIndex],
    );
  }
}

// ==========================
// STORAGE PAGE + DIALOGS
// ==========================
class StoragePage extends StatelessWidget {
  final int userId;
  final List<Filamento> filamentos;
  final List<Acessorio> acessorios;
  final VoidCallback onReload;

  const StoragePage({
    super.key,
    required this.userId,
    required this.filamentos,
    required this.acessorios,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Filamentos em Stock", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ElevatedButton(
              child: const Text("Adicionar Filamento"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () async {
                final res = await showDialog<Filamento>(
                  context: context,
                  builder: (ctx) => const FilamentoDialog(),
                );
                if (res != null) {
                  await DatabaseHelper.instance.insertFilamento(res.toMap(), userId);
                  onReload();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (filamentos.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            child: const Text(
              "Nenhum filamento cadastrado.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ...filamentos.map((f) => Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0.5,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: _getColorFromName(f.cor),
              child: Text(f.cor.isNotEmpty ? f.cor[0].toUpperCase() : "?"),
            ),
            title: Text("${f.fabricante} - ${f.cor}", style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(
              "Stock inicial: ${f.gramas}g | Stock atual: ${f.stockAtual}g\n"
              "Compra: ${f.dataCompra.day}/${f.dataCompra.month}/${f.dataCompra.year}\n"
              "Preço: €${f.precoCompra.toStringAsFixed(2)} | Posição: ${f.posicaoNota}\nEstado: ${f.danificado ? 'Danificado/Humidade' : 'Bom'}"
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                actionButton(
                  text: "Editar",
                  color: Colors.blue,
                  onTap: () async {
                    final res = await showDialog<Filamento>(
                      context: context,
                      builder: (ctx) => FilamentoDialog(editFilamento: f),
                    );
                    if (res != null) {
                      await DatabaseHelper.instance.updateFilamento(res.toMap(), f.id!);
                      onReload();
                    }
                  },
                ),
                const SizedBox(width: 8),
                actionButton(
                  text: "Excluir",
                  color: Colors.red,
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Confirmação"),
                        content: Text("Deseja realmente excluir ${f.fabricante} - ${f.cor}?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text("Excluir"),
                          ),
                        ],
                      ),
                    );
                    
                    if (confirm == true) {
                      await DatabaseHelper.instance.deleteFilamento(f.id!);
                      onReload();
                    }
                  },
                ),
              ],
            ),
          ),
        )),
        const Divider(height: 36),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Acessórios Disponíveis", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ElevatedButton(
              child: const Text("Adicionar Acessório"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () async {
                final res = await showDialog<Acessorio>(
                  context: context,
                  builder: (ctx) => const AcessorioDialog(),
                );
                if (res != null) {
                  await DatabaseHelper.instance.insertAcessorio(res.toMap(), userId);
                  onReload();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (acessorios.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            child: const Text(
              "Nenhum acessório cadastrado.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ...acessorios.map((a) => Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0.5,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(a.nome, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text("Quantidade: ${a.quantidade} | Preço: €${a.precoCompra.toStringAsFixed(2)}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                actionButton(
                  text: "Editar",
                  color: Colors.blue,
                  onTap: () async {
                    final res = await showDialog<Acessorio>(
                      context: context,
                      builder: (ctx) => AcessorioDialog(editAcessorio: a),
                    );
                    if (res != null) {
                      await DatabaseHelper.instance.updateAcessorio(res.toMap(), a.id!);
                      onReload();
                    }
                  },
                ),
                const SizedBox(width: 8),
                actionButton(
                  text: "Excluir",
                  color: Colors.red,
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Confirmação"),
                        content: Text("Deseja realmente excluir ${a.nome}?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text("Excluir"),
                          ),
                        ],
                      ),
                    );
                    
                    if (confirm == true) {
                      await DatabaseHelper.instance.deleteAcessorio(a.id!);
                      onReload();
                    }
                  },
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
  
  Color _getColorFromName(String colorName) {
    final Map<String, Color> colorMap = {
      'vermelho': Colors.red,
      'red': Colors.red,
      'verde': Colors.green,
      'green': Colors.green,
      'azul': Colors.blue,
      'blue': Colors.blue,
      'amarelo': Colors.yellow,
      'yellow': Colors.yellow,
      'preto': Colors.black,
      'black': Colors.black,
      'branco': Colors.white,
      'white': Colors.white,
      'laranja': Colors.orange,
      'orange': Colors.orange,
      'roxo': Colors.purple,
      'purple': Colors.purple,
      'rosa': Colors.pink,
      'pink': Colors.pink,
      'cinza': Colors.grey,
      'grey': Colors.grey,
      'gray': Colors.grey,
      'marrom': Colors.brown,
      'brown': Colors.brown,
      'transparente': Colors.transparent,
      'transparent': Colors.transparent,
    };
    
    String normalizedName = colorName.toLowerCase();
    
    for (var entry in colorMap.entries) {
      if (normalizedName.contains(entry.key)) {
        return entry.value;
      }
    }
    
    return Colors.deepPurple.shade100; // Default color
  }
}

class FilamentoDialog extends StatefulWidget {
  final Filamento? editFilamento;
  const FilamentoDialog({super.key, this.editFilamento});

  @override
  State<FilamentoDialog> createState() => _FilamentoDialogState();
}

class _FilamentoDialogState extends State<FilamentoDialog> {
  final _formKey = GlobalKey<FormState>();
  late String fabricante;
  late int gramas;
  DateTime? dataCompra;
  late double precoCompra;
  late bool danificado;
  late String posicaoNota;
  late String cor;

  @override
  void initState() {
    super.initState();
    final f = widget.editFilamento;
    fabricante = f?.fabricante ?? "";
    gramas = f?.gramas ?? 0;
    dataCompra = f?.dataCompra;
    precoCompra = f?.precoCompra ?? 0.0;
    danificado = f?.danificado ?? false;
    posicaoNota = f?.posicaoNota ?? "";
    cor = f?.cor ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.editFilamento == null ? "Novo Filamento" : "Editar Filamento"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: fabricante,
                decoration: const InputDecoration(
                  labelText: "Fabricante",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? "Obrigatório" : null,
                onSaved: (v) => fabricante = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: cor,
                decoration: const InputDecoration(
                  labelText: "Cor",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? "Obrigatório" : null,
                onSaved: (v) => cor = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: gramas.toString(),
                decoration: const InputDecoration(
                  labelText: "Gramas em stock",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null ? "Número" : null,
                onSaved: (v) => gramas = int.parse(v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: precoCompra.toStringAsFixed(2),
                decoration: const InputDecoration(
                  labelText: "Preço de compra (€)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || double.tryParse(v.replaceAll(',', '.')) == null ? "Valor" : null,
                onSaved: (v) => precoCompra = double.parse(v!.replaceAll(',', '.')),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: posicaoNota,
                decoration: const InputDecoration(
                  labelText: "Posição/Nota",
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) => posicaoNota = v ?? '',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text("Data de compra: "),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                    ),
                    child: Text(dataCompra == null
                        ? "Escolher"
                        : "${dataCompra!.day}/${dataCompra!.month}/${dataCompra!.year}"),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: dataCompra ?? DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Colors.deepPurple.shade600,
                                onPrimary: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) setState(() => dataCompra = picked);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: danificado,
                    onChanged: (v) => setState(() => danificado = v!),
                    activeColor: Colors.deepPurple,
                  ),
                  const Text("Danificado/Humidade"),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar")),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate() && dataCompra != null) {
                _formKey.currentState!.save();
                Navigator.pop(
                  context,
                  Filamento(
                      fabricante: fabricante,
                      gramas: gramas,
                      stockAtual: widget.editFilamento?.stockAtual ?? gramas,
                      dataCompra: dataCompra!,
                      precoCompra: precoCompra,
                      danificado: danificado,
                      posicaoNota: posicaoNota,
                      cor: cor),
                );
              } else if (dataCompra == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Selecione a data de compra")),
                );
              }
            },
            child: const Text("Salvar")),
      ],
    );
  }
}

class AcessorioDialog extends StatefulWidget {
  final Acessorio? editAcessorio;
  const AcessorioDialog({super.key, this.editAcessorio});

  @override
  State<AcessorioDialog> createState() => _AcessorioDialogState();
}

class _AcessorioDialogState extends State<AcessorioDialog> {
  final _formKey = GlobalKey<FormState>();
  late String nome;
  late int quantidade;
  late double precoCompra;

  @override
  void initState() {
    super.initState();
    final a = widget.editAcessorio;
    nome = a?.nome ?? "";
    quantidade = a?.quantidade ?? 0;
    precoCompra = a?.precoCompra ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.editAcessorio == null ? "Novo Acessório" : "Editar Acessório"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: nome,
              decoration: const InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.isEmpty ? "Obrigatório" : null,
              onSaved: (v) => nome = v!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: quantidade.toString(),
              decoration: const InputDecoration(
                labelText: "Quantidade",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || int.tryParse(v) == null ? "Número" : null,
              onSaved: (v) => quantidade = int.parse(v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: precoCompra.toStringAsFixed(2),
              decoration: const InputDecoration(
                labelText: "Preço de compra (€)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || double.tryParse(v.replaceAll(',', '.')) == null ? "Valor" : null,
              onSaved: (v) => precoCompra = double.parse(v!.replaceAll(',', '.')),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Cancelar")),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.pop(context, Acessorio(nome: nome, quantidade: quantidade, precoCompra: precoCompra));
              }
            },
            child: const Text("Salvar")),
      ],
    );
  }
}

// ==== ModelsPage (Gestão de Modelos 3D) ====
class ModelsPage extends StatelessWidget {
  final int userId;
  final List<Modelo3D> modelos;
  final List<Filamento> filamentos;
  final List<Acessorio> acessorios;
  final List<Cliente> clientes;
  final double precoKwhUser;
  final VoidCallback onReload;
  final Future<void> Function(Gasto) onAddGasto;

  const ModelsPage({
    super.key,
    required this.userId,
    required this.modelos,
    required this.filamentos,
    required this.acessorios,
    required this.clientes,
    required this.precoKwhUser,
    required this.onReload,
    required this.onAddGasto,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Projetos de Modelos 3D", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ElevatedButton(
              child: const Text("Novo Modelo"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () async {
                if (filamentos.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Adicione primeiro um filamento!")),
                  );
                  return;
                }
                final res = await showDialog<Modelo3D>(
                  context: context,
                  builder: (ctx) => Modelo3DDialog(
                    filamentos: filamentos,
                    acessorios: acessorios,
                    clientes: clientes,
                    precoKwhUser: precoKwhUser,
                  ),
                );
                if (res != null) {
                  // Verificar stock de todos os filamentos usados
                  bool filamentoInsuficiente = false;
                  String mensagemErro = "";
                  
                  for (var filamentoUsado in res.filamentosUsados) {
                    final filamento = filamentos.firstWhere(
                      (f) => f.id == filamentoUsado.filamentoId,
                      orElse: () => Filamento(
                        fabricante: '', 
                        gramas: 0, 
                        stockAtual: 0, 
                        dataCompra: DateTime.now(), 
                        precoCompra: 0, 
                        danificado: false, 
                        posicaoNota: '', 
                        cor: ''
                      )
                    );
                    
                    if (filamento.stockAtual < filamentoUsado.gramasUsados) {
                      filamentoInsuficiente = true;
                      mensagemErro = "Filamento ${filamento.cor} (${filamento.fabricante}) insuficiente em stock!";
                      break;
                    }
                  }
                  
                  if (filamentoInsuficiente) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(mensagemErro)),
                    );
                    return;
                  }
                  
                  // Verifica stock dos acessórios
                  bool acessorioFalta = false;
                  if (res.acessoriosUsados.isNotEmpty) {
                    final acessoriosList = res.acessoriosUsados.split(',');
                    for (final acc in acessoriosList) {
                      if (acc.trim().isEmpty) continue;
                      final parts = acc.split(':');
                      if (parts.length == 2) {
                        final nome = parts[0];
                        final quantidade = int.tryParse(parts[1]) ?? 0;
                        final match = acessorios.where((a) => a.nome == nome);
                        if (match.isEmpty || quantidade > match.first.quantidade) {
                          acessorioFalta = true;
                          break;
                        }
                      }
                    }
                  }
                  
                  if (acessorioFalta) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Acessório insuficiente em stock!")),
                    );
                    return;
                  }
                  
                  // Salva o modelo
                  await DatabaseHelper.instance.insertModelo(res.toMap(), userId);
                  
                  // Atualiza o stock de todos os filamentos usados
                  for (var filamentoUsado in res.filamentosUsados) {
                    final filamento = filamentos.firstWhere((f) => f.id == filamentoUsado.filamentoId);
                    final novoStockAtual = (filamento.stockAtual - filamentoUsado.gramasUsados).clamp(0, 999999);
                    await DatabaseHelper.instance.updateFilamentoStockAtual(filamento.id!, novoStockAtual);
                  }
                  
                  // Atualiza stock dos acessórios usados
                  if (res.acessoriosUsados.isNotEmpty) {
                    final acessoriosList = res.acessoriosUsados.split(',');
                    for (final acc in acessoriosList) {
                      if (acc.trim().isEmpty) continue;
                      final parts = acc.split(':');
                      if (parts.length == 2) {
                        final nome = parts[0];
                        final quantidade = int.tryParse(parts[1]) ?? 0;
                        final match = acessorios.where((a) => a.nome == nome);
                        if (match.isNotEmpty && quantidade > 0) {
                          final acessorio = match.first;
                          final novaQtd = (acessorio.quantidade - quantidade).clamp(0, 999999);
                          await DatabaseHelper.instance.updateAcessorioQuantidade(acessorio.id!, novaQtd);
                        }
                      }
                    }
                  }
                  
                  // Registra o gasto de energia
                  if (res.custoEnergia > 0) {
                    await onAddGasto(Gasto(
                      descricao: "Energia - ${res.nome}",
                      valor: res.custoEnergia,
                      data: DateTime.now(),
                    ));
                  }
                  
                  onReload();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (modelos.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            child: const Text(
              "Nenhum modelo registrado.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ...modelos.map((m) => Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0.5,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        m.nome,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    actionButton(
                      text: "Excluir",
                      color: Colors.red,
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Confirmação"),
                            content: Text("Deseja realmente excluir o modelo ${m.nome}?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text("Excluir"),
                              ),
                            ],
                          ),
                        );
                        
                        if (confirm == true) {
                          await DatabaseHelper.instance.deleteModelo(m.id!);
                          onReload();
                        }
                      },
                    ),
                  ],
                ),
                const Divider(),
                const Text("Filamentos utilizados:", style: TextStyle(fontWeight: FontWeight.w500)),
                ...m.filamentosUsados.map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: _getColorFromName(f.cor),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                      Text("${f.cor} (${f.gramasUsados}g): €${f.custo.toStringAsFixed(2)}"),
                    ],
                  ),
                )).toList(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Acessórios: €${m.custoAcessorios.toStringAsFixed(2)}"),
                    Text("Energia: ${m.energiaKwh.toStringAsFixed(2)}kWh (€${m.custoEnergia.toStringAsFixed(2)})"),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          const TextSpan(text: "Custo: "),
                          TextSpan(
                            text: "€${m.custoTotal.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          const TextSpan(text: "Venda: "),
                          TextSpan(
                            text: "€${(m.precoVenda ?? 0).toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  "Cliente: ${m.clienteOuPessoal == "Cliente" ? (m.clienteNome ?? '') : "Pessoal"}",
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Color _getColorFromName(String colorName) {
    final Map<String, Color> colorMap = {
      'vermelho': Colors.red,
      'red': Colors.red,
      'verde': Colors.green,
      'green': Colors.green,
      'azul': Colors.blue,
      'blue': Colors.blue,
      'amarelo': Colors.yellow,
      'yellow': Colors.yellow,
      'preto': Colors.black,
      'black': Colors.black,
      'branco': Colors.grey.shade300,
      'white': Colors.grey.shade300,
      'laranja': Colors.orange,
      'orange': Colors.orange,
      'roxo': Colors.purple,
      'purple': Colors.purple,
      'rosa': Colors.pink,
      'pink': Colors.pink,
      'cinza': Colors.grey,
      'grey': Colors.grey,
      'gray': Colors.grey,
      'marrom': Colors.brown,
      'brown': Colors.brown,
    };
    
    String normalizedName = colorName.toLowerCase();
    
    for (var entry in colorMap.entries) {
      if (normalizedName.contains(entry.key)) {
        return entry.value;
      }
    }
    
    return Colors.deepPurple.shade100; // Default color
  }
}

// ==== Modelo3DDialog ====
class Modelo3DDialog extends StatefulWidget {
  final List<Filamento> filamentos;
  final List<Acessorio> acessorios;
  final List<Cliente> clientes;
  final double precoKwhUser;
  const Modelo3DDialog({
    super.key,
    required this.filamentos,
    required this.acessorios,
    required this.clientes,
    required this.precoKwhUser,
  });

  @override
  State<Modelo3DDialog> createState() => _Modelo3DDialogState();
}

class _Modelo3DDialogState extends State<Modelo3DDialog> {
  final _formKey = GlobalKey<FormState>();
  String nome = "";
  int tempoMinutos = 0;
  String clienteOuPessoal = "Pessoal";
  int? clienteId;
  String? clienteNome;
  double custoEnergia = 0.0;
  double custoFilamento = 0.0;
  double custoAcessorios = 0.0;
  double custoTotal = 0.0;
  double energiaKwh = 0.0;
  double? precoVenda = 0;
  double potenciaPadraoKw = 0.13; // 130W
  
  // Lista de filamentos usados no modelo
  List<FilamentoUsado> filamentosUsados = [];
  Map<int, int> acessoriosSelecionados = {};

  @override
  void initState() {
    super.initState();
    // Adicionar o primeiro filamento vazio para o usuário começar
    if (widget.filamentos.isNotEmpty) {
      _addFilamento();
    }
  }

  void _addFilamento() {
    if (widget.filamentos.isEmpty) return;
    
    setState(() {
      filamentosUsados.add(
        FilamentoUsado(
          filamentoId: widget.filamentos.first.id!,
          cor: widget.filamentos.first.cor,
          fabricante: widget.filamentos.first.fabricante,
          gramasUsados: 0,
          custo: 0.0
        )
      );
    });
  }

  void _removeFilamento(int index) {
    if (filamentosUsados.length <= 1) return; // Manter pelo menos um filamento
    
    setState(() {
      filamentosUsados.removeAt(index);
      calcularCustos();
    });
  }

  void _updateFilamentoId(int index, int filamentoId) {
    final filamento = widget.filamentos.firstWhere((f) => f.id == filamentoId);
    setState(() {
      filamentosUsados[index].filamentoId = filamentoId;
      filamentosUsados[index].cor = filamento.cor;
      filamentosUsados[index].fabricante = filamento.fabricante;
      calcularCustos();
    });
  }

  void _updateGramas(int index, int gramas) {
    setState(() {
      filamentosUsados[index].gramasUsados = gramas;
      calcularCustos();
    });
  }

  void calcularCustos() {
    custoFilamento = 0.0;
    
    // Calcular custo para cada filamento usado
    for (int i = 0; i < filamentosUsados.length; i++) {
      final filamento = widget.filamentos.firstWhere(
        (f) => f.id == filamentosUsados[i].filamentoId,
        orElse: () => widget.filamentos.first
      );
      
      double custoIndividual = (filamento.gramas == 0)
        ? 0
        : (filamentosUsados[i].gramasUsados / filamento.gramas) * filamento.precoCompra;
      
      filamentosUsados[i].custo = custoIndividual;
      custoFilamento += custoIndividual;
    }

    custoAcessorios = 0.0;
    if (acessoriosSelecionados.isNotEmpty) {
      for (var entry in acessoriosSelecionados.entries) {
        final ac = widget.acessorios.firstWhere((a) => a.id == entry.key);
        custoAcessorios += entry.value * ac.precoCompra;
      }
    }
    
    energiaKwh = ((tempoMinutos / 60.0) * potenciaPadraoKw);
    custoEnergia = energiaKwh * widget.precoKwhUser;
    custoTotal = custoFilamento + custoAcessorios + custoEnergia;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Novo Modelo 3D"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Nome do Modelo",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? "Obrigatório" : null,
                  onSaved: (v) => nome = v!,
                ),
                
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Filamentos utilizados:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(filamentosUsados.length, (index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Filamento ${index + 1}", 
                                          style: const TextStyle(fontWeight: FontWeight.bold))
                                    ),
                                    if (filamentosUsados.length > 1)
                                      TextButton(
                                        child: const Text("Remover"),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        onPressed: () => _removeFilamento(index),
                                      )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<int>(
                                  value: filamentosUsados[index].filamentoId,
                                  decoration: const InputDecoration(
                                    labelText: "Tipo de filamento",
                                    border: OutlineInputBorder(),
                                  ),
                                  items: widget.filamentos
                                      .map((f) => DropdownMenuItem<int>(
                                          value: f.id, 
                                          child: Text("${f.cor} (${f.fabricante})")
                                      ))
                                      .toList(),
                                  onChanged: (v) => _updateFilamentoId(index, v!),
                                  validator: (v) => v == null ? "Selecione o filamento" : null,
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  initialValue: filamentosUsados[index].gramasUsados.toString(),
                                  decoration: const InputDecoration(
                                    labelText: "Gramas Utilizadas",
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (v) => v == null || int.tryParse(v) == null ? "Número" : null,
                                  onChanged: (v) {
                                    final gramas = int.tryParse(v) ?? 0;
                                    _updateGramas(index, gramas);
                                  },
                                ),
                                                               if (filamentosUsados[index].custo > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: Colors.green.shade100),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "Custo: ",
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            "€${filamentosUsados[index].custo.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                      
                      // Botão para adicionar mais filamentos
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text("Adicionar Filamento"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _addFilamento,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tempo e Energia:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: tempoMinutos.toString(),
                        decoration: const InputDecoration(
                          labelText: "Tempo de impressão (minutos)",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || int.tryParse(v) == null ? "Minutos" : null,
                        onChanged: (v) {
                          tempoMinutos = int.tryParse(v) ?? 0;
                          setState(() {
                            energiaKwh = ((tempoMinutos / 60.0) * potenciaPadraoKw);
                            calcularCustos();
                          });
                        },
                        onSaved: (v) => tempoMinutos = int.parse(v!),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: (potenciaPadraoKw * 1000).toStringAsFixed(0),
                              decoration: const InputDecoration(
                                labelText: "Potência impressora (W)",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (v) {
                                double w = double.tryParse(v) ?? 130.0;
                                setState(() {
                                  potenciaPadraoKw = w / 1000.0;
                                  energiaKwh = ((tempoMinutos / 60.0) * potenciaPadraoKw);
                                  calcularCustos();
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.blue.shade100),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Consumo:"),
                                Text(
                                  "${energiaKwh.toStringAsFixed(3)} kWh",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Cliente:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: clienteOuPessoal,
                        decoration: const InputDecoration(
                          labelText: "Destino",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: "Pessoal", child: Text("Pessoal")),
                          DropdownMenuItem(value: "Cliente", child: Text("Cliente")),
                        ],
                        onChanged: (v) => setState(() => clienteOuPessoal = v ?? "Pessoal"),
                        onSaved: (v) => clienteOuPessoal = v ?? "Pessoal",
                      ),
                      if (clienteOuPessoal == "Cliente") 
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            if (widget.clientes.isNotEmpty)
                              DropdownButtonFormField<int>(
                                decoration: const InputDecoration(
                                  labelText: "Cliente",
                                  border: OutlineInputBorder(),
                                ),
                                value: widget.clientes.isNotEmpty ? widget.clientes.first.id : null,
                                items: widget.clientes
                                    .map((c) => DropdownMenuItem<int>(
                                        value: c.id, child: Text(c.nome)))
                                    .toList(),
                                onChanged: (v) {
                                  clienteId = v;
                                  clienteNome = widget.clientes.firstWhere((c) => c.id == v).nome;
                                },
                                onSaved: (v) {
                                  clienteId = v;
                                  clienteNome = v != null ? widget.clientes.firstWhere((c) => c.id == v).nome : null;
                                },
                                validator: (v) => clienteOuPessoal == "Cliente" && v == null ? "Selecione o cliente" : null,
                              )
                            else
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.info_outline, color: Colors.orange),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: Text("Nenhum cliente cadastrado. Adicione clientes na seção de Gestão de Clientes."),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                if (widget.acessorios.isNotEmpty) Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Acessórios:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      ...widget.acessorios.map((a) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(a.nome, style: const TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            SizedBox(
                              width: 80,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "0",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                ),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                initialValue: "0",
                                onChanged: (v) {
                                  final qtd = int.tryParse(v) ?? 0;
                                  setState(() {
                                    if (qtd > 0) {
                                      acessoriosSelecionados[a.id!] = qtd;
                                    } else {
                                      acessoriosSelecionados.remove(a.id!);
                                    }
                                    calcularCustos();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Preço de venda:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: (precoVenda ?? 0.0).toString(),
                        decoration: const InputDecoration(
                          labelText: "Preço de venda (€)",
                          border: OutlineInputBorder(),
                          prefixText: "€ ",
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (v) {
                          precoVenda = double.tryParse(v.replaceAll(',', '.')) ?? 0;
                        },
                        onSaved: (v) =>
                            precoVenda = double.tryParse(v!.replaceAll(',', '.')) ?? 0,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Preço de luz atual: €${widget.precoKwhUser.toStringAsFixed(3)} por kWh",
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              calcularCustos();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Recalcular Custos"),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple.shade50, Colors.blue.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "RESUMO DOS CUSTOS",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildCostRow("Filamentos:", custoFilamento),
                      _buildCostRow("Acessórios:", custoAcessorios),
                      _buildCostRow("Energia:", custoEnergia),
                      const Divider(color: Colors.grey),
                      _buildCostRow("Total:", custoTotal, isTotal: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar")),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                calcularCustos();
                
                // Verificar se há pelo menos um filamento com gramas > 0
                bool temFilamento = filamentosUsados.any((f) => f.gramasUsados > 0);
                if (!temFilamento) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Adicione pelo menos um filamento com peso > 0"))
                  );
                  return;
                }
                
                // Preparar string de acessórios
                String accString = "";
                if (acessoriosSelecionados.isNotEmpty) {
                  for (var entry in acessoriosSelecionados.entries) {
                    final ac = widget.acessorios.firstWhere((a) => a.id == entry.key);
                    accString += "${ac.nome}:${entry.value},";
                  }
                }
                
                Navigator.pop(
                  context,
                  Modelo3D(
                    nome: nome,
                    filamentosUsados: filamentosUsados,
                    tempoMinutos: tempoMinutos,
                    clienteOuPessoal: clienteOuPessoal,
                    clienteId: clienteId,
                    clienteNome: clienteNome,
                    energiaKwh: energiaKwh,
                    custoEnergia: custoEnergia,
                    custoFilamento: custoFilamento,
                    custoAcessorios: custoAcessorios,
                    custoTotal: custoTotal,
                    acessoriosUsados: accString,
                    precoVenda: precoVenda,
                    dataCriacao: DateTime.now(),
                  ),
                );
              }
            },
            child: const Text("Salvar")),
      ],
    );
  }
  
  Widget _buildCostRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            "€${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.deepPurple : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// ==== ClientsPage (Gestão de Clientes) ====
class ClientsPage extends StatelessWidget {
  final int userId;
  final List<Cliente> clientes;
  final List<Modelo3D> modelos;
  final VoidCallback onReload;

  const ClientsPage({
    super.key,
    required this.userId,
    required this.clientes,
    required this.modelos,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Clientes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ElevatedButton(
              child: const Text("Adicionar Cliente"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () async {
                final res = await showDialog<Cliente>(
                  context: context,
                  builder: (ctx) => const ClienteDialog(),
                );
                if (res != null) {
                  await DatabaseHelper.instance.insertCliente(res.toMap(), userId);
                  onReload();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (clientes.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            child: const Text(
              "Nenhum cliente cadastrado.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ...clientes.map((c) => Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0.5,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ExpansionTile(
                title: Text(c.nome, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text("${c.email} • ${c.objetivo}"),
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                childrenPadding: const EdgeInsets.all(16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (c.mensagem.isNotEmpty) Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Mensagem:", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(c.mensagem),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                  const Text("Projetos deste cliente:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  ...modelos
                      .where((m) => m.clienteId == c.id)
                      .map((m) => Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(m.nome, style: const TextStyle(fontWeight: FontWeight.w500)),
                                  Text(
                                    "${m.dataCriacao?.day}/${m.dataCriacao?.month}/${m.dataCriacao?.year}",
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "€${m.custoTotal.toStringAsFixed(2)}",
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ))
                      .toList(),
                  if (modelos.where((m) => m.clienteId == c.id).isEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.center,
                      child: const Text(
                        "Sem projetos associados",
                        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Confirmação"),
                              content: Text("Deseja realmente excluir o cliente ${c.nome}?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text("Cancelar"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text("Excluir"),
                                ),
                              ],
                            ),
                          );
                          
                          if (confirm == true) {
                            await DatabaseHelper.instance.deleteCliente(c.id!);
                            onReload();
                          }
                        },
                        child: const Text("Excluir Cliente"),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

// Continuing from where we left off
class ClienteDialog extends StatefulWidget {
  const ClienteDialog({super.key});
  @override
  State<ClienteDialog> createState() => _ClienteDialogState();
}

class _ClienteDialogState extends State<ClienteDialog> {
  final _formKey = GlobalKey<FormState>();
  String nome = "";
  String email = "";
  String mensagem = "";
  String objetivo = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Novo Cliente"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Nome",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? "Obrigatório" : null,
                  onSaved: (v) => nome = v!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? "Obrigatório" : null,
                  onSaved: (v) => email = v!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Objetivo",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? "Obrigatório" : null,
                  onSaved: (v) => objetivo = v!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Mensagem",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onSaved: (v) => mensagem = v ?? "",
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar")),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.pop(
                  context,
                  Cliente(
                    nome: nome,
                    email: email,
                    mensagem: mensagem,
                    objetivo: objetivo,
                  ),
                );
              }
            },
            child: const Text("Salvar")),
      ],
    );
  }
}

// ==== AccountingPage (PieChart) ====
class AccountingPage extends StatelessWidget {
  final List<Modelo3D> modelos;
  final List<Gasto> gastos;
  final List<Filamento> filamentos;
  final List<Acessorio> acessorios;

  const AccountingPage({
    super.key,
    required this.modelos,
    required this.gastos,
    required this.filamentos,
    required this.acessorios,
  });

  @override
  Widget build(BuildContext context) {
    double totalEnergia = modelos.fold(0, (sum, m) => sum + m.energiaKwh);
    double custoEnergia = modelos.fold(0, (sum, m) => sum + m.custoEnergia);
    double gastoFilamento = modelos.fold(0, (sum, m) => sum + m.custoFilamento);
    double gastoAcessorios = modelos.fold(0, (sum, m) => sum + m.custoAcessorios);
    double gastoOutros = gastos.fold(0, (s, g) => s + g.valor);

    double ganhos = modelos
        .where((m) => (m.clienteOuPessoal == "Cliente" || m.clienteId != null) && (m.precoVenda ?? 0) > 0)
        .fold(0.0, (sum, m) => sum + (m.precoVenda ?? 0));
    double custos = custoEnergia + gastoFilamento + gastoAcessorios + gastoOutros;
    double lucro = ganhos - custos;

    final gastosData = [
      PieChartSectionData(
        value: gastoFilamento,
        color: Colors.deepPurple,
        title: "FLMTs",
        radius: 55,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: gastoAcessorios,
        color: Colors.orange,
        title: "ACRs",
        radius: 55,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: custoEnergia,
        color: Colors.green,
        title: "Energia",
        radius: 55,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: gastoOutros,
        color: Colors.red,
        title: "Outros",
        radius: 55,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ].where((d) => d.value > 0).toList();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text("Resumo Contábil", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        Card(
          color: Colors.green[50],
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Ganhos em vendas", 
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("Total ganho: €${ganhos.toStringAsFixed(2)}"),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "€",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          color: lucro >= 0 ? Colors.green[100] : Colors.red[100],
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Lucro Líquido", 
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("Lucro: €${lucro.toStringAsFixed(2)}"),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: lucro >= 0 ? Colors.green.shade200 : Colors.red.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      lucro >= 0 ? "+" : "-",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: lucro >= 0 ? Colors.green.shade800 : Colors.red.shade800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.pie_chart, color: Colors.deepPurple.shade400),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Distribuição dos Custos", 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
                child: gastosData.isEmpty 
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            const Text("Sem dados suficientes", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: PieChart(
                          PieChartData(
                            sections: gastosData,
                            centerSpaceRadius: 50,
                            sectionsSpace: 4,
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
              ),
              if (gastosData.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLegendItem("Filamentos", Colors.deepPurple),
                      _buildLegendItem("Acessórios", Colors.orange),
                      _buildLegendItem("Energia", Colors.green),
                      _buildLegendItem("Outros", Colors.red),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text("Resumo por Categoria", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _summaryCard("Energia", "${totalEnergia.toStringAsFixed(2)} kWh\nCusto: €${custoEnergia.toStringAsFixed(2)}"),
            _summaryCard("Filamento", "Gasto total: €${gastoFilamento.toStringAsFixed(2)}"),
            _summaryCard("Acessórios", "Gasto total: €${gastoAcessorios.toStringAsFixed(2)}"),
            _summaryCard("Outros Gastos", "Outros gastos: €${gastoOutros.toStringAsFixed(2)}"),
          ],
        ),
        const SizedBox(height: 20),
        const Text("Lançamentos Recentes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...gastos.map((g) => Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(g.descricao),
            subtitle: Text("${g.data.day}/${g.data.month}/${g.data.year}"),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "€${g.valor.toStringAsFixed(2)}",
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )),
        if (gastos.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            child: const Text(
              "Nenhum lançamento registrado.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _summaryCard(String title, String value) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 175,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// ==== SettingsPage ====
class SettingsPage extends StatelessWidget {
  final double precoKwhUser;
  final VoidCallback onEditarPrecoKwh;

  const SettingsPage({
    super.key,
    required this.precoKwhUser,
    required this.onEditarPrecoKwh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(
                Icons.settings_applications,
                size: 72,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 16),
              const Text(
                "Definições",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Configurações de Energia",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Preço da luz atual",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "€${precoKwhUser.toStringAsFixed(3)} por kWh",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: onEditarPrecoKwh,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Alterar"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 0,
                color: Colors.grey.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Informações",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Outras definições poderão ser acrescentadas em atualizações futuras. "
                        "Entre em contato com o suporte para mais informações.",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Versão: 1.0.0",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              Text(
                "Atualizado em: 05/08/2025",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              Text(
                "By SKYPT",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}