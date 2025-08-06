import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../db/database_helper.dart';
import 'dart:convert';
import 'modelo3d_dialog.dart';

// ============ ENHANCED THEME ==============
final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2A3042),
    primary: const Color(0xFF2A3042),
    secondary: const Color(0xFF4475F2),
    tertiary: const Color(0xFF1FAD66),
    error: const Color(0xFFE74C3C),
    background: const Color(0xFFF9FAFB),
    surface: Colors.white,
    brightness: Brightness.light,
  ),
  fontFamily: 'Inter',
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF9FAFB),
    foregroundColor: Color(0xFF2A3042),
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFF2A3042),
    ),
  ),
  scaffoldBackgroundColor: const Color(0xFFF9FAFB),
  cardTheme: CardThemeData(
  elevation: 0.5,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  clipBehavior: Clip.antiAlias,
  color: Colors.white,
  shadowColor: Colors.black.withOpacity(0.1),
),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Color(0xFF4475F2), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Color(0xFFE74C3C)),
    ),
    labelStyle: TextStyle(color: Colors.grey.shade700),
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey.shade200,
    thickness: 1,
    space: 24,
  ),
);

// ============ ENHANCED SEARCH BAR ==========
Widget searchBar({
  required String hint,
  required TextEditingController controller,
  required Function(String) onChanged,
  VoidCallback? onClear,
}) {
  return Container(
    height: 48,
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20),
        suffixIcon: controller.text.isNotEmpty 
            ? IconButton(
                icon: Icon(Icons.clear, color: Colors.grey.shade500, size: 18),
                onPressed: onClear,
              ) 
            : null,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: onChanged,
    ),
  );
}

// ============ ENHANCED ACTION BUTTON ==========
Widget actionButton({
  required String text,
  required VoidCallback onTap,
  String? tooltip,
  IconData? icon,
  double fontSize = 14,
  EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  bool isSecondary = false,
  bool isDangerous = false,
}) {
  return Tooltip(
    message: tooltip ?? '',
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDangerous 
            ? const Color(0xFFE74C3C)
            : isSecondary 
                ? Colors.grey.shade100 
                : const Color(0xFF2A3042),
        foregroundColor: isSecondary ? const Color(0xFF2A3042) : Colors.white,
        padding: padding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 0,
      ),
      onPressed: onTap,
      child: icon != null 
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Text(
                  text, 
                  style: TextStyle(
                    fontSize: fontSize, 
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  )
                ),
              ],
            )
          : Text(
              text, 
              style: TextStyle(
                fontSize: fontSize, 
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              )
            ),
    ),
  );
}

// ====================
// DATA MODELS - Unchanged
// ====================
class Impressora {
  int? id;
  String nome;
  double potenciaKw;

  Impressora({
    this.id,
    required this.nome,
    required this.potenciaKw,
  });

  Map<String, dynamic> toMap() => {
        "nome": nome,
        "potencia_kw": potenciaKw,
      };

  factory Impressora.fromMap(Map<String, dynamic> map) => Impressora(
        id: map['id'],
        nome: map['nome'] ?? '',
        potenciaKw: (map['potencia_kw'] ?? 0.13).toDouble(),
      );
}

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
  int? impressoraId;
  String? impressoraNome;

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
    this.impressoraId,
    this.impressoraNome,
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
        "impressora_id": impressoraId,
        "impressora_nome": impressoraNome,
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
      impressoraId: map['impressora_id'],
      impressoraNome: map['impressora_nome'],
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
// ENHANCED MAIN BLANK SCREEN
// ==========================
class BlankScreen extends StatefulWidget {
  final int userId;
  const BlankScreen({super.key, required this.userId});

  @override
  State<BlankScreen> createState() => _BlankScreenState();
}

class _BlankScreenState extends State<BlankScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  
  List<Filamento> filamentos = [];
  List<Acessorio> acessorios = [];
  List<Modelo3D> modelos = [];
  List<Cliente> clientes = [];
  List<Gasto> gastos = [];
  List<Impressora> impressoras = [];
  double precoKwhUser = 0.25;

  final List<String> _titles = [
    "Gestão de Armazenamento",
    "Gestão de Modelos 3D",
    "Gestão de Clientes",
    "Contabilidade",
    "Definições"
  ];
  
  final List<IconData> _icons = [
    Icons.inventory_2_outlined,
    Icons.view_in_ar_outlined,
    Icons.people_outline,
    Icons.account_balance_wallet_outlined,
    Icons.settings_outlined
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadAll();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
  precoKwhUser = await DatabaseHelper.instance.getUserPrecoKwh(widget.userId);
  await Future.wait([
    _loadFilamentos(),
    _loadAcessorios(),
    _loadModelos(),
    _loadClientes(),
    _loadGastos(), // <- GARANTA QUE ISSO É CHAMADO
    _loadImpressoras(),
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

  Future<void> _loadImpressoras() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final data = await db.query(
        'impressora', 
        where: 'user_id = ?', 
        whereArgs: [widget.userId]
      );
      
      setState(() {
        impressoras = data.map((e) => Impressora.fromMap(e)).toList();
      });
      
      // Add default printer if none exists
      if (impressoras.isEmpty) {
        await _addDefaultImpressora();
      }
    } catch (e) {
      // Create table if not exists
      await _createImpressoraTable();
      await _addDefaultImpressora();
    }
  }

  Future<void> _createImpressoraTable() async {
    final db = await DatabaseHelper.instance.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS impressora(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        potencia_kw REAL,
        user_id INTEGER
      )
    ''');
  }

  Future<void> _addDefaultImpressora() async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('impressora', {
      'nome': 'Impressora Padrão',
      'potencia_kw': 0.13,
      'user_id': widget.userId
    });
    await _loadImpressoras();
  }

  void _onSelectMenu(int index) {
    setState(() {
      _selectedIndex = index;
      _animationController.reset();
      _animationController.forward();
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
          TextButton(
            onPressed: () => Navigator.pop(c), 
            child: Text("Cancelar", style: TextStyle(color: Colors.grey.shade700)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
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
        impressoras: impressoras,
        precoKwhUser: precoKwhUser,
        onReload: _loadAll,
        onAddGasto: (g) async {
  await DatabaseHelper.instance.insertGasto(g.toMap(), widget.userId);
  await _loadGastos(); // <- Atualiza os gastos!
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
  gastos: gastos, // <- Aqui vai a lista atualizada
  filamentos: filamentos,
  acessorios: acessorios,
),
      SettingsPage(
        userId: widget.userId,
        precoKwhUser: precoKwhUser,
        impressoras: impressoras,
        onEditarPrecoKwh: () => _editarPrecoKwh(context),
        onReload: _loadAll,
        onManageImpressora: (impressora, isDelete) async {
          final db = await DatabaseHelper.instance.database;
          
          if (isDelete) {
            if (impressora.id != null) {
              await db.delete(
                'impressora',
                where: 'id = ?',
                whereArgs: [impressora.id]
              );
            }
          } else {
            if (impressora.id != null) {
              await db.update(
                'impressora',
                impressora.toMap()..addAll({'user_id': widget.userId}),
                where: 'id = ?',
                whereArgs: [impressora.id]
              );
            } else {
              await db.insert(
                'impressora',
                impressora.toMap()..addAll({'user_id': widget.userId})
              );
            }
          }
          
          await _loadImpressoras();
        },
      ),
    ];
    
    return Theme(
      data: appTheme,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Row(
            children: [
              Icon(_icons[_selectedIndex], size: 22),
              const SizedBox(width: 10),
              Text(_titles[_selectedIndex]),
            ],
          ),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            tooltip: 'Menu',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_outlined),
              onPressed: _loadAll,
              tooltip: 'Atualizar dados',
            ),
            const SizedBox(width: 8),
          ],
        ),
        drawer: Drawer(
          elevation: 1,
          child: Column(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2A3042), Color(0xFF3B4156)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.view_in_ar_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'SKYPT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Sistema de Gestão para Impressão 3D',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Atualizado: 2025-08-06 15:28:55',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _titles.length,
                  itemBuilder: (context, i) {
                    bool isSelected = _selectedIndex == i;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected 
                            ? const Color(0xFF4475F2).withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      child: ListTile(
                        leading: Icon(
                          _icons[i], 
                          color: isSelected ? const Color(0xFF4475F2) : Colors.grey.shade700,
                          size: 22,
                        ),
                        title: Text(
                          _titles[i],
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 14,
                            color: isSelected ? const Color(0xFF4475F2) : Colors.grey.shade800,
                          ),
                        ),
                        selected: isSelected,
                        onTap: () => _onSelectMenu(i),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline, size: 22),
                title: const Text('Sobre', style: TextStyle(fontSize: 14)),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (ctx) => AboutDialog(
                      applicationName: 'SKYPT - Gestão 3D',
                      applicationVersion: '1.1.0',
                      applicationIcon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A3042),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.view_in_ar_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      children: const [
                        SizedBox(height: 16),
                        Text(
                          'Sistema avançado para gestão de impressoras 3D, filamentos, clientes, e contabilidade.',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '© 2025 SKYPT. Todos os direitos reservados.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 4),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: pages[_selectedIndex],
        ),
      ),
    );
  }
}

// ==========================
// ENHANCED STORAGE PAGE & DIALOGS
// ==========================
class StoragePage extends StatefulWidget {
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
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  final TextEditingController _filamentosSearchController = TextEditingController();
  final TextEditingController _acessoriosSearchController = TextEditingController();
  
  List<Filamento> _filteredFilamentos = [];
  List<Acessorio> _filteredAcessorios = [];
  bool _showFilamentosLow = false;
  
  @override
  void initState() {
    super.initState();
    _filteredFilamentos = List.from(widget.filamentos);
    _filteredAcessorios = List.from(widget.acessorios);
  }
  
  @override
  void didUpdateWidget(StoragePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filamentos != widget.filamentos || 
        oldWidget.acessorios != widget.acessorios) {
      _filterFilamentos(_filamentosSearchController.text);
      _filterAcessorios(_acessoriosSearchController.text);
    }
  }
  
  void _filterFilamentos(String query) {
    setState(() {
      List<Filamento> filtered = List.from(widget.filamentos);
      
      // Filter by search query if not empty
      if (query.isNotEmpty) {
        filtered = filtered.where((f) => 
            f.fabricante.toLowerCase().contains(query.toLowerCase()) ||
            f.cor.toLowerCase().contains(query.toLowerCase()) ||
            f.posicaoNota.toLowerCase().contains(query.toLowerCase()))
        .toList();
      }
      
      // Apply low stock filter if enabled
      if (_showFilamentosLow) {
        filtered = filtered.where((f) => f.stockAtual < 100).toList();
      }
      
      _filteredFilamentos = filtered;
    });
  }
  
  void _filterAcessorios(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredAcessorios = List.from(widget.acessorios);
      } else {
        _filteredAcessorios = widget.acessorios
            .where((a) => 
                a.nome.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
  
  @override
  void dispose() {
    _filamentosSearchController.dispose();
    _acessoriosSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get low stock items
    final lowStockFilamentos = widget.filamentos.where((f) => f.stockAtual < 100).length;
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          // Stats cards row
          Row(
            children: [
              _buildStatCard(
                icon: Icons.inventory_2_outlined,
                title: "Filamentos",
                value: widget.filamentos.length.toString(),
                color: const Color(0xFF4475F2),
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                icon: Icons.warning_amber_outlined,
                title: "Stock Baixo",
                value: lowStockFilamentos.toString(),
                color: const Color(0xFFFF9500),
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                icon: Icons.category_outlined,
                title: "Acessórios",
                value: widget.acessorios.length.toString(),
                color: const Color(0xFF1FAD66),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    "Filamentos em Stock", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
                  ),
                  const SizedBox(width: 12),
                  // Filter chip for low stock
                  FilterChip(
                    label: const Text("Stock Baixo"),
                    selected: _showFilamentosLow,
                    onSelected: (selected) {
                      setState(() {
                        _showFilamentosLow = selected;
                        _filterFilamentos(_filamentosSearchController.text);
                      });
                    },
                    avatar: Icon(
                      Icons.warning_amber_rounded, 
                      size: 18, 
                      color: _showFilamentosLow ? Colors.white : Colors.amber,
                    ),
                    selectedColor: Colors.amber,
                    labelStyle: TextStyle(
                      color: _showFilamentosLow ? Colors.white : Colors.black87,
                      fontWeight: _showFilamentosLow ? FontWeight.w500 : FontWeight.normal,
                    ),
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.amber.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )
                ],
              ),
              actionButton(
                text: "Adicionar Filamento",
                icon: Icons.add,
                onTap: () async {
                  final res = await showDialog<Filamento>(
                    context: context,
                    builder: (ctx) => FilamentoDialog(
                      allFilamentos: widget.filamentos,
                    ),
                  );
                  if (res != null) {
                    await DatabaseHelper.instance.insertFilamento(res.toMap(), widget.userId);
                    widget.onReload();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Barra de pesquisa para filamentos
          searchBar(
            hint: "Pesquisar filamentos por nome, cor ou posição...",
            controller: _filamentosSearchController,
            onChanged: _filterFilamentos,
            onClear: () {
              _filamentosSearchController.clear();
              _filterFilamentos('');
            },
          ),
          
          if (_filteredFilamentos.isEmpty && widget.filamentos.isNotEmpty)
            _buildEmptyState("Nenhum filamento encontrado com os filtros atuais.", Icons.search_off),
          if (_filteredFilamentos.isEmpty && widget.filamentos.isEmpty)
            _buildEmptyState("Nenhum filamento cadastrado. Adicione seu primeiro filamento.", Icons.inventory_2_outlined),
            
          ..._filteredFilamentos.map((f) => _buildFilamentoCard(f, context)),
          
          const SizedBox(height: 32),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Acessórios Disponíveis", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
              ),
              actionButton(
                text: "Adicionar Acessório",
                icon: Icons.add,
                onTap: () async {
                  final res = await showDialog<Acessorio>(
                    context: context,
                    builder: (ctx) => const AcessorioDialog(),
                  );
                  if (res != null) {
                    await DatabaseHelper.instance.insertAcessorio(res.toMap(), widget.userId);
                    widget.onReload();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Barra de pesquisa para acessórios
          searchBar(
            hint: "Pesquisar acessórios por nome...",
            controller: _acessoriosSearchController,
            onChanged: _filterAcessorios,
            onClear: () {
              _acessoriosSearchController.clear();
              _filterAcessorios('');
            },
          ),
          
          if (_filteredAcessorios.isEmpty && widget.acessorios.isNotEmpty)
            _buildEmptyState("Nenhum acessório encontrado com a busca atual.", Icons.search_off),
          if (_filteredAcessorios.isEmpty && widget.acessorios.isEmpty)
            _buildEmptyState("Nenhum acessório cadastrado. Adicione seu primeiro acessório.", Icons.category_outlined),
            
          ..._filteredAcessorios.map((a) => _buildAcessorioCard(a, context)),
        ],
      ),
    );
  }
  
  Widget _buildFilamentoCard(Filamento f, BuildContext context) {
    // Calculate percentage of stock remaining
    final percentageLeft = (f.stockAtual / f.gramas * 100).clamp(0, 100).toInt();
    final bool isLowStock = f.stockAtual < 100;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: _getColorFromName(f.cor), width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Color circle
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getColorFromName(f.cor),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Info section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${f.fabricante} - ${f.cor}",
                                style: const TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (f.danificado)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.red.shade100),
                                ),
                                child: Text(
                                  "Danificado",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red.shade800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Stock info with progress bar
                        Row(
                          children: [
                            Text(
                              "Stock: ${f.stockAtual}g de ${f.gramas}g",
                              style: TextStyle(
                                color: isLowStock ? Colors.red.shade800 : Colors.grey.shade800,
                                fontWeight: isLowStock ? FontWeight.w500 : FontWeight.normal,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "$percentageLeft%",
                              style: TextStyle(
                                color: isLowStock ? Colors.red.shade800 : Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: percentageLeft / 100,
                            backgroundColor: Colors.grey.shade200,
                            color: isLowStock ? Colors.red.shade400 : const Color(0xFF4475F2),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Additional info
                        Row(
                          children: [
                            _buildInfoChip(
                              label: "Compra: ${f.dataCompra.day}/${f.dataCompra.month}/${f.dataCompra.year}",
                              icon: Icons.date_range,
                            ),
                            const SizedBox(width: 8),
                            _buildInfoChip(
                              label: "€${f.precoCompra.toStringAsFixed(2)}",
                              icon: Icons.euro,
                            ),
                          ],
                        ),
                        if (f.posicaoNota.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: _buildInfoChip(
                              label: "Local: ${f.posicaoNota}",
                              icon: Icons.place,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Action buttons
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  actionButton(
                    text: "Editar",
                    icon: Icons.edit_outlined,
                    isSecondary: true,
                    onTap: () async {
                      final res = await showDialog<Filamento>(
                        context: context,
                        builder: (ctx) => FilamentoDialog(
                          editFilamento: f,
                          allFilamentos: widget.filamentos,
                        ),
                      );
                      if (res != null) {
                        await DatabaseHelper.instance.updateFilamento(res.toMap(), f.id!);
                        widget.onReload();
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  actionButton(
                    text: "Excluir",
                    icon: Icons.delete_outline,
                    isDangerous: true,
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
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text("Excluir"),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirm == true) {
                        await DatabaseHelper.instance.deleteFilamento(f.id!);
                        widget.onReload();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcessorioCard(Acessorio a, BuildContext context) {
    final bool lowStock = a.quantidade <= 2;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: Color(0xFF1FAD66), width: 4)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon container
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1FAD66).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.category_outlined,
                        color: Color(0xFF1FAD66),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Info section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.nome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: lowStock ? Colors.red.shade50 : const Color(0xFF1FAD66).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: lowStock ? Colors.red.shade200 : const Color(0xFF1FAD66).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 16,
                                    color: lowStock ? Colors.red.shade700 : const Color(0xFF1FAD66),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${a.quantidade} unidades",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: lowStock ? Colors.red.shade700 : const Color(0xFF1FAD66),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4475F2).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF4475F2).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.euro,
                                    size: 16,
                                    color: Color(0xFF4475F2),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    a.precoCompra.toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF4475F2),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Action buttons
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  actionButton(
                    text: "Editar",
                    icon: Icons.edit_outlined,
                    isSecondary: true,
                    onTap: () async {
                      final res = await showDialog<Acessorio>(
                        context: context,
                        builder: (ctx) => AcessorioDialog(editAcessorio: a),
                      );
                      if (res != null) {
                        await DatabaseHelper.instance.updateAcessorio(res.toMap(), a.id!);
                        widget.onReload();
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  actionButton(
                    text: "Excluir",
                    icon: Icons.delete_outline,
                    isDangerous: true,
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
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text("Excluir"),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirm == true) {
                        await DatabaseHelper.instance.deleteAcessorio(a.id!);
                        widget.onReload();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoChip({required String label, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.grey.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(icon, color: color, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32),
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600, 
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getColorFromName(String colorName) {
    final Map<String, Color> colorMap = {
      'vermelho': Colors.red,
      'red': Colors.red,
      'verde': Colors.green,
      'green': Colors.green,
      'azul': const Color(0xFF4475F2),
      'blue': const Color(0xFF4475F2),
      'amarelo': Colors.amber,
      'yellow': Colors.amber,
      'preto': Colors.black,
      'black': Colors.black,
      'branco': Colors.grey.shade200,
      'white': Colors.grey.shade200,
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
    
    return const Color(0xFF2A3042); // Default color
  }
}

// Enhanced FilamentoDialog - largely preserving the functionality
class FilamentoDialog extends StatefulWidget {
  final Filamento? editFilamento;
  final List<Filamento>? allFilamentos;
  
  const FilamentoDialog({super.key, this.editFilamento, this.allFilamentos});

  @override
  State<FilamentoDialog> createState() => _FilamentoDialogState();
}

// Rest of the code continues with similar improvements...
// For brevity, I'm focusing on the main layout and design patterns.

class _FilamentoDialogState extends State<FilamentoDialog> {
  final _formKey = GlobalKey<FormState>();
  late String fabricante;
  late int gramas;
  late int stockAtual;
  DateTime? dataCompra;
  late double precoCompra;
  late bool danificado;
  late String posicaoNota;
  late String cor;
  
  // Lists for autocomplete
  List<String> fabricantes = [];
  List<String> cores = [];

  @override
  void initState() {
    super.initState();
    final f = widget.editFilamento;
    fabricante = f?.fabricante ?? "";
    gramas = f?.gramas ?? 0;
    stockAtual = f?.stockAtual ?? 0;
        dataCompra = f?.dataCompra ?? DateTime.now();
    precoCompra = f?.precoCompra ?? 0.0;
    danificado = f?.danificado ?? false;
    posicaoNota = f?.posicaoNota ?? "";
    cor = f?.cor ?? "";
    
    // Extract unique fabricantes and cores from existing filamentos
    if (widget.allFilamentos != null) {
      fabricantes = widget.allFilamentos!
          .map((f) => f.fabricante)
          .toSet()
          .toList();
      
      cores = widget.allFilamentos!
          .map((f) => f.cor)
          .toSet()
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.editFilamento != null;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dialog Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A3042),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? "Editar Filamento" : "Novo Filamento",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section title
                      Text(
                        "Informações Básicas",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Fabricante dropdown
                      const Text(
                        "Fabricante",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: fabricantes.contains(fabricante) ? fabricante : null,
                        decoration: const InputDecoration(
                          hintText: "Selecione um fabricante",
                          prefixIcon: Icon(Icons.business_outlined),
                        ),
                        items: [
                          if (!fabricantes.contains(fabricante) && fabricante.isNotEmpty)
                            DropdownMenuItem(value: fabricante, child: Text(fabricante)),
                          ...fabricantes.map((f) => DropdownMenuItem(value: f, child: Text(f))),
                        ],
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              fabricante = value;
                            });
                          }
                        },
                        isExpanded: true,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: fabricante,
                        decoration: const InputDecoration(
                          labelText: "Ou digite um novo fabricante",
                          prefixIcon: Icon(Icons.add_business_outlined),
                        ),
                        onChanged: (value) {
                          setState(() {
                            fabricante = value;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Cor dropdown
                      const Text(
                        "Cor",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: cores.contains(cor) ? cor : null,
                        decoration: const InputDecoration(
                          hintText: "Selecione uma cor",
                          prefixIcon: Icon(Icons.color_lens_outlined),
                        ),
                        items: [
                          if (!cores.contains(cor) && cor.isNotEmpty)
                            DropdownMenuItem(value: cor, child: Text(cor)),
                          ...cores.map((c) => DropdownMenuItem(value: c, child: Text(c))),
                        ],
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              cor = value;
                            });
                          }
                        },
                        isExpanded: true,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: cor,
                        decoration: const InputDecoration(
                          labelText: "Ou digite uma nova cor",
                          prefixIcon: Icon(Icons.palette_outlined),
                        ),
                        onChanged: (value) {
                          setState(() {
                            cor = value;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Section title
                      Text(
                        "Stock e Preço",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Stock info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: gramas.toString(),
                              decoration: const InputDecoration(
                                labelText: "Stock inicial (gramas)",
                                prefixIcon: Icon(Icons.inventory_2_outlined),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) => v == null || int.tryParse(v) == null ? "Insira um número válido" : null,
                              onSaved: (v) => gramas = int.parse(v!),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              initialValue: isEditing ? stockAtual.toString() : gramas.toString(),
                              decoration: const InputDecoration(
                                labelText: "Stock atual (gramas)",
                                prefixIcon: Icon(Icons.bar_chart),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) => v == null || int.tryParse(v) == null ? "Insira um número válido" : null,
                              onSaved: (v) => stockAtual = int.parse(v!),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Price and position
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: precoCompra.toStringAsFixed(2),
                              decoration: const InputDecoration(
                                labelText: "Preço de compra (€)",
                                prefixIcon: Icon(Icons.euro),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (v) => v == null || double.tryParse(v.replaceAll(',', '.')) == null ? "Insira um valor válido" : null,
                              onSaved: (v) => precoCompra = double.parse(v!.replaceAll(',', '.')),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              initialValue: posicaoNota,
                              decoration: const InputDecoration(
                                labelText: "Posição/Nota",
                                prefixIcon: Icon(Icons.place_outlined),
                              ),
                              onSaved: (v) => posicaoNota = v ?? '',
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Data de compra e estado
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Data de compra",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: dataCompra ?? DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime.now().add(const Duration(days: 30)),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: const ColorScheme.light(
                                              primary: Color(0xFF2A3042),
                                              onPrimary: Colors.white,
                                              surface: Colors.white,
                                              onSurface: Colors.black,
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (picked != null) setState(() => dataCompra = picked);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today, color: Colors.grey.shade600, size: 18),
                                        const SizedBox(width: 10),
                                        Text(
                                          dataCompra != null
                                              ? "${dataCompra!.day.toString().padLeft(2, '0')}/${dataCompra!.month.toString().padLeft(2, '0')}/${dataCompra!.year}"
                                              : "Selecionar data",
                                          style: TextStyle(
                                            color: dataCompra != null ? Colors.black87 : Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Estado do filamento",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      danificado = !danificado;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(
                                              color: danificado ? Colors.red : Colors.grey.shade500,
                                              width: 2,
                                            ),
                                            color: danificado ? Colors.red : Colors.transparent,
                                          ),
                                          child: danificado
                                              ? const Icon(Icons.check, color: Colors.white, size: 16)
                                              : null,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          "Danificado/Humidade",
                                          style: TextStyle(
                                            color: danificado ? Colors.red : Colors.grey.shade800,
                                            fontWeight: danificado ? FontWeight.w500 : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Dialog actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancelar", style: TextStyle(color: Colors.grey.shade700)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A3042),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() && dataCompra != null) {
                        _formKey.currentState!.save();
                        Navigator.pop(
                          context,
                          Filamento(
                            id: widget.editFilamento?.id,
                            fabricante: fabricante,
                            gramas: gramas,
                            stockAtual: stockAtual,
                            dataCompra: dataCompra!,
                            precoCompra: precoCompra,
                            danificado: danificado,
                            posicaoNota: posicaoNota,
                            cor: cor,
                          ),
                        );
                      } else if (dataCompra == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Selecione a data de compra"),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.save_outlined, size: 18),
                        SizedBox(width: 8),
                        Text("Guardar", style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Enhanced AcessorioDialog with modern UI
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
    final bool isEditing = widget.editAcessorio != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dialog Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1FAD66),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.category_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? "Editar Acessório" : "Novo Acessório",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Form Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: nome,
                      decoration: const InputDecoration(
                        labelText: "Nome do Acessório",
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      validator: (v) => v == null || v.isEmpty ? "Nome é obrigatório" : null,
                      onSaved: (v) => nome = v!,
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: quantidade.toString(),
                            decoration: const InputDecoration(
                              labelText: "Quantidade",
                              prefixIcon: Icon(Icons.inventory_2_outlined),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) => v == null || int.tryParse(v) == null ? "Insira um número válido" : null,
                            onSaved: (v) => quantidade = int.parse(v!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            initialValue: precoCompra.toStringAsFixed(2),
                            decoration: const InputDecoration(
                              labelText: "Preço de compra (€)",
                              prefixIcon: Icon(Icons.euro),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (v) => v == null || double.tryParse(v.replaceAll(',', '.')) == null ? "Insira um valor válido" : null,
                            onSaved: (v) => precoCompra = double.parse(v!.replaceAll(',', '.')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Dialog actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancelar", style: TextStyle(color: Colors.grey.shade700)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1FAD66),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Navigator.pop(
                          context,
                          Acessorio(
                            id: widget.editAcessorio?.id,
                            nome: nome,
                            quantidade: quantidade,
                            precoCompra: precoCompra,
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.save_outlined, size: 18),
                        SizedBox(width: 8),
                        Text("Guardar", style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==== ModelsPage (Gestão de Modelos 3D) - Enhanced ====
class ModelsPage extends StatefulWidget {
  final int userId;
  final List<Modelo3D> modelos;
  final List<Filamento> filamentos;
  final List<Acessorio> acessorios;
  final List<Cliente> clientes;
  final List<Impressora> impressoras;
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
    required this.impressoras,
    required this.precoKwhUser,
    required this.onReload,
    required this.onAddGasto,
  });

  @override
  State<ModelsPage> createState() => _ModelsPageState();
}

class _ModelsPageState extends State<ModelsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Modelo3D> _filteredModelos = [];
  String _filterType = 'all'; // 'all', 'client', 'personal'
  
  @override
  void initState() {
    super.initState();
    _filteredModelos = List.from(widget.modelos);
  }
  
  @override
  void didUpdateWidget(ModelsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.modelos != widget.modelos) {
      _applyFilters();
    }
  }
  
  void _filterModelos(String query) {
    setState(() {
      _applyFilters(query);
    });
  }
  
  void _applyFilters([String? query]) {
    query ??= _searchController.text;
    List<Modelo3D> filtered = List.from(widget.modelos);
    
    // Apply search query
    if (query.isNotEmpty) {
      filtered = filtered.where((m) => 
        m.nome.toLowerCase().contains(query!.toLowerCase()) ||
        (m.clienteNome?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
        m.filamentosUsados.any((f) => 
          f.cor.toLowerCase().contains(query!.toLowerCase()) ||
          f.fabricante.toLowerCase().contains(query.toLowerCase())
        )
      ).toList();
    }
    
    // Apply type filter
    if (_filterType == 'client') {
      filtered = filtered.where((m) => m.clienteOuPessoal == "Cliente" || m.clienteId != null).toList();
    } else if (_filterType == 'personal') {
      filtered = filtered.where((m) => m.clienteOuPessoal == "Pessoal").toList();
    }
    
    _filteredModelos = filtered;
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate stats
    final totalModelos = widget.modelos.length;
    final clientModelos = widget.modelos.where((m) => m.clienteOuPessoal == "Cliente" || m.clienteId != null).length;
    final personalModelos = widget.modelos.where((m) => m.clienteOuPessoal == "Pessoal").length;
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          // Stats cards row
          Row(
            children: [
              _buildStatCard(
                icon: Icons.view_in_ar_outlined,
                title: "Total de Modelos",
                value: totalModelos.toString(),
                color: const Color(0xFF4475F2),
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                icon: Icons.business_outlined,
                title: "Modelos para Clientes",
                value: clientModelos.toString(),
                color: const Color(0xFF1FAD66),
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                icon: Icons.person_outline,
                title: "Modelos Pessoais",
                value: personalModelos.toString(),
                color: Colors.deepPurple.shade400,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Projetos de Modelos 3D",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              actionButton(
                text: "Novo Modelo",
                icon: Icons.add,
                onTap: () async {
                  if (widget.filamentos.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Adicione primeiro um filamento!"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  final res = await showDialog<Modelo3D>(
                    context: context,
                    builder: (ctx) => Modelo3DDialog(
                      filamentos: widget.filamentos,
                      acessorios: widget.acessorios,
                      clientes: widget.clientes,
                      impressoras: widget.impressoras,
                      precoKwhUser: widget.precoKwhUser,
                    ),
                  );
                  if (res != null) {
                    // Verificar stock de todos os filamentos usados
                    bool filamentoInsuficiente = false;
                    String mensagemErro = "";
                    
                    for (var filamentoUsado in res.filamentosUsados) {
                      final filamento = widget.filamentos.firstWhere(
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
                        SnackBar(
                          content: Text(mensagemErro),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
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
                          final match = widget.acessorios.where((a) => a.nome == nome);
                          if (match.isEmpty || quantidade > match.first.quantidade) {
                            acessorioFalta = true;
                            break;
                          }
                        }
                      }
                    }
                    
                    if (acessorioFalta) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Acessório insuficiente em stock!"),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    
                    // Salva o modelo
                    await DatabaseHelper.instance.insertModelo(res.toMap(), widget.userId);
                    
                    // Atualiza o stock de todos os filamentos usados
                    for (var filamentoUsado in res.filamentosUsados) {
                      final filamento = widget.filamentos.firstWhere((f) => f.id == filamentoUsado.filamentoId);
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
                          final match = widget.acessorios.where((a) => a.nome == nome);
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
  await widget.onAddGasto(Gasto(
    descricao: "Energia - ${res.nome}",
    valor: res.custoEnergia,
    data: DateTime.now(),
  ));
}
widget.onReload(); // <- Isto força a atualização!
                    
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Modelo ${res.nome} adicionado com sucesso!"),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    
                    widget.onReload();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Filters and search row
          Row(
            children: [
              // Filter chips
              ChoiceChip(
                label: const Text("Todos"),
                selected: _filterType == 'all',
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _filterType = 'all';
                      _applyFilters();
                    });
                  }
                },
                selectedColor: const Color(0xFF4475F2).withOpacity(0.1),
                labelStyle: TextStyle(
                  color: _filterType == 'all' ? const Color(0xFF4475F2) : Colors.grey.shade800,
                  fontWeight: _filterType == 'all' ? FontWeight.w500 : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                avatar: Icon(
                  Icons.all_inclusive,
                  size: 18,
                  color: _filterType == 'all' ? const Color(0xFF4475F2) : Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text("Clientes"),
                selected: _filterType == 'client',
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _filterType = 'client';
                      _applyFilters();
                    });
                  }
                },
                selectedColor: const Color(0xFF1FAD66).withOpacity(0.1),
                labelStyle: TextStyle(
                  color: _filterType == 'client' ? const Color(0xFF1FAD66) : Colors.grey.shade800,
                  fontWeight: _filterType == 'client' ? FontWeight.w500 : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                avatar: Icon(
                  Icons.business_outlined,
                  size: 18,
                  color: _filterType == 'client' ? const Color(0xFF1FAD66) : Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text("Pessoal"),
                selected: _filterType == 'personal',
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _filterType = 'personal';
                      _applyFilters();
                    });
                  }
                },
                selectedColor: Colors.deepPurple.shade100,
                labelStyle: TextStyle(
                  color: _filterType == 'personal' ? Colors.deepPurple.shade700 : Colors.grey.shade800,
                  fontWeight: _filterType == 'personal' ? FontWeight.w500 : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                avatar: Icon(
                  Icons.person_outline,
                  size: 18,
                  color: _filterType == 'personal' ? Colors.deepPurple.shade700 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 16),
              // Search bar
              Expanded(
                child: searchBar(
                  hint: "Pesquisar modelos por nome, cliente ou filamento...",
                  controller: _searchController,
                  onChanged: _filterModelos,
                  onClear: () {
                    _searchController.clear();
                    _filterModelos('');
                  },
                ),
              ),
            ],
          ),
          
          if (_filteredModelos.isEmpty && widget.modelos.isNotEmpty)
            _buildEmptyState("Nenhum modelo encontrado com os filtros atuais.", Icons.search_off),
         if (_filteredModelos.isEmpty && widget.modelos.isEmpty)
            _buildEmptyState("Nenhum modelo registrado. Adicione seu primeiro modelo 3D.", Icons.view_in_ar_outlined),
          
         // List of models
         ..._filteredModelos.map((m) => _buildModeloCard(m, context)),
        ],
      ),
    );
  }

  Widget _buildModeloCard(Modelo3D m, BuildContext context) {
    final bool isClientProject = m.clienteOuPessoal == "Cliente" || m.clienteId != null;
    final Color primaryColor = isClientProject ? const Color(0xFF1FAD66) : Colors.deepPurple.shade400;
    final Color bgColor = isClientProject ? const Color(0xFF1FAD66).withOpacity(0.05) : Colors.deepPurple.withOpacity(0.05);
    
    // Calculate profit percentage if price is set
    double? profitPercentage;
    if (m.precoVenda != null && m.precoVenda! > 0 && m.custoTotal > 0) {
      profitPercentage = ((m.precoVenda! - m.custoTotal) / m.custoTotal) * 100;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: primaryColor, width: 4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section with model name and actions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Model name and type badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.view_in_ar_rounded,
                            color: primaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.nome,
                              style: const TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: primaryColor.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isClientProject ? Icons.business_outlined : Icons.person_outline,
                                    size: 14,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isClientProject ? (m.clienteNome ?? "Cliente") : "Pessoal",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Action buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit_outlined, color: Colors.grey.shade700),
                          tooltip: "Editar modelo",
                          onPressed: () async {
                            final res = await showDialog<Modelo3D>(
                              context: context,
                              builder: (ctx) => Modelo3DDialog(
                                editModelo: m,
                                filamentos: widget.filamentos,
                                acessorios: widget.acessorios,
                                clientes: widget.clientes,
                                impressoras: widget.impressoras,
                                precoKwhUser: widget.precoKwhUser,
                              ),
                            );
                            if (res != null) {
                              // Update the model
                              await DatabaseHelper.instance.updateModelo(res.toMap(), m.id!);
                              widget.onReload();
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.grey.shade700),
                          tooltip: "Excluir modelo",
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(
                                  "Excluir Modelo",
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                                content: Text("Deseja realmente excluir o modelo '${m.nome}'? Esta ação não pode ser desfeita."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text("Cancelar"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text("Excluir"),
                                  ),
                                ],
                              ),
                            );
                            
                            if (confirm == true) {
                              await DatabaseHelper.instance.deleteModelo(m.id!);
                              widget.onReload();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Details grid: materials, time, energy
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filament section
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(
                                title: "Materiais utilizados",
                                icon: Icons.category_outlined,
                              ),
                              const SizedBox(height: 10),
                              if (m.filamentosUsados.isEmpty)
                                const Text(
                                  "Nenhum filamento registrado",
                                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Column(
                                    children: m.filamentosUsados.map((f) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 14,
                                            height: 14,
                                            margin: const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              color: _getColorFromName(f.cor),
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.grey.shade300, width: 1),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${f.fabricante} - ${f.cor}",
                                              style: const TextStyle(fontSize: 13),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "${f.gramasUsados}g",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF4475F2).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              "€${f.custo.toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                color: Color(0xFF4475F2),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )).toList(),
                                  ),
                                ),
                              
                              // Accessories section if any
                              if (m.acessoriosUsados.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Icon(Icons.build_outlined, size: 16, color: Colors.grey.shade700),
                                    const SizedBox(width: 6),
                                    const Text(
                                      "Acessórios:",
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1FAD66).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "€${m.custoAcessorios.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Color(0xFF1FAD66),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  m.acessoriosUsados,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Time and energy section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(
                                title: "Tempo e Energia",
                                icon: Icons.schedule_outlined,
                              ),
                              const SizedBox(height: 10),
                              // Print time
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.timer_outlined, size: 16, color: Colors.grey.shade700),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatTime(m.tempoMinutos),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Energy usage
                                    Row(
                                      children: [
                                        Icon(Icons.bolt_outlined, size: 16, color: Colors.amber.shade700),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${m.energiaKwh.toStringAsFixed(2)} kWh",
                                              style: const TextStyle(fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              "€${m.custoEnergia.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    if (m.impressoraNome != null) ...[
                                      const SizedBox(height: 12),
                                      // Printer info
                                      Row(
                                        children: [
                                          Icon(Icons.print_outlined, size: 16, color: Colors.grey.shade700),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              m.impressoraNome!,
                                              style: const TextStyle(fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Date info
                              if (m.dataCriacao != null)
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade600),
                                    const SizedBox(width: 6),
                                    Text(
                                      _formatDate(m.dataCriacao!),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    // Pricing info section
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A3042).withOpacity(0.03),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          // Costs column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Custo Total",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "€${m.custoTotal.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2A3042),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Filamentos: €${m.custoFilamento.toStringAsFixed(2)} • Energia: €${m.custoEnergia.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Price column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Preço de Venda",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      "€${(m.precoVenda ?? 0).toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: m.precoVenda != null && m.precoVenda! > 0 ? const Color(0xFF1FAD66) : Colors.grey.shade500,
                                      ),
                                    ),
                                    if (profitPercentage != null) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: profitPercentage > 0 ? Colors.green.shade50 : Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: profitPercentage > 0 ? Colors.green.shade200 : Colors.red.shade200,
                                          ),
                                        ),
                                        child: Text(
                                          profitPercentage > 0 ? "+${profitPercentage.toStringAsFixed(0)}%" : "${profitPercentage.toStringAsFixed(0)}%",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: profitPercentage > 0 ? Colors.green.shade800 : Colors.red.shade800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                if (m.precoVenda != null && m.precoVenda! > 0 && m.custoTotal > 0) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    "Lucro: €${(m.precoVenda! - m.custoTotal).toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  String _formatTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    
    if (hours > 0) {
      return "$hours${hours == 1 ? " hora" : " horas"}${mins > 0 ? " e $mins min" : ""}";
    } else {
      return "$mins minutos";
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day/$month/${date.year}";
  }
  
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(icon, color: color, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40),
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            icon,
            size: 56,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600, 
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getColorFromName(String colorName) {
    final Map<String, Color> colorMap = {
      'vermelho': Colors.red,
      'red': Colors.red,
      'verde': Colors.green,
      'green': Colors.green,
      'azul': const Color(0xFF4475F2),
      'blue': const Color(0xFF4475F2),
      'amarelo': Colors.amber,
      'yellow': Colors.amber,
      'preto': Colors.black,
      'black': Colors.black,
      'branco': Colors.grey.shade200,
      'white': Colors.grey.shade200,
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
    
        return const Color(0xFF2A3042); // Default color
  }
}

// ==== ClientsPage (Gestão de Clientes) - Enhanced ====
class ClientsPage extends StatefulWidget {
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
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Cliente> _filteredClientes = [];
  
  @override
  void initState() {
    super.initState();
    _filteredClientes = List.from(widget.clientes);
  }
  
  @override
  void didUpdateWidget(ClientsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.clientes != widget.clientes) {
      _filterClientes(_searchController.text);
    }
  }
  
  void _filterClientes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredClientes = List.from(widget.clientes);
      } else {
        _filteredClientes = widget.clientes
            .where((c) => 
                c.nome.toLowerCase().contains(query.toLowerCase()) ||
                c.email.toLowerCase().contains(query.toLowerCase()) ||
                c.objetivo.toLowerCase().contains(query.toLowerCase()) ||
                c.mensagem.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate stats
    final activeClients = widget.clientes.where((c) => 
      widget.modelos.any((m) => m.clienteId == c.id)).length;
    final totalProjects = widget.modelos.where((m) => 
      m.clienteOuPessoal == "Cliente" || m.clienteId != null).length;
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          // Stats cards row
          Row(
            children: [
              _buildStatCard(
                icon: Icons.people_outline,
                title: "Total de Clientes",
                value: widget.clientes.length.toString(),
                color: const Color(0xFF4475F2),
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                icon: Icons.person_search_outlined,
                title: "Clientes Ativos",
                value: "$activeClients",
                color: const Color(0xFF1FAD66),
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                icon: Icons.view_in_ar_outlined,
                title: "Projetos para Clientes",
                value: "$totalProjects",
                color: Colors.deepPurple.shade400,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Gerenciar Clientes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              actionButton(
                text: "Adicionar Cliente",
                icon: Icons.person_add_outlined,
                onTap: () async {
                  final res = await showDialog<Cliente>(
                    context: context,
                    builder: (ctx) => const ClienteDialog(),
                  );
                  if (res != null) {
                    await DatabaseHelper.instance.insertCliente(res.toMap(), widget.userId);
                    widget.onReload();
                    
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Cliente adicionado com sucesso!"),
                        backgroundColor: Color(0xFF1FAD66),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Barra de pesquisa para clientes
          searchBar(
            hint: "Pesquisar clientes por nome, email ou objetivo...",
            controller: _searchController,
            onChanged: _filterClientes,
            onClear: () {
              _searchController.clear();
              _filterClientes('');
            },
          ),
          
          if (_filteredClientes.isEmpty && widget.clientes.isNotEmpty)
            _buildEmptyState("Nenhum cliente encontrado com os critérios atuais.", Icons.search_off),
         if (_filteredClientes.isEmpty && widget.clientes.isEmpty)
            _buildEmptyState("Nenhum cliente cadastrado. Adicione seu primeiro cliente.", Icons.people_outline),
          
          // List of clients
          ..._filteredClientes.map((c) => _buildClientCard(c)),
        ],
      ),
    );
  }

  Widget _buildClientCard(Cliente c) {
    // Get projects for this client
    final clientProjects = widget.modelos.where((m) => m.clienteId == c.id).toList();
    final bool hasProjects = clientProjects.isNotEmpty;
    
    // Calculate total value and cost of projects
    final totalValue = clientProjects.fold(0.0, (sum, m) => sum + (m.precoVenda ?? 0));
    final totalCost = clientProjects.fold(0.0, (sum, m) => sum + m.custoTotal);
    final profit = totalValue - totalCost;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: const Color(0xFF4475F2), width: 4)),
        ),
        child: Column(
          children: [
            // Client header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Client avatar
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4475F2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Center(
                      child: Text(
                        c.nome.isNotEmpty ? c.nome.substring(0, 1).toUpperCase() : "?",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4475F2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Client info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.nome,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.email_outlined, size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                c.email,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1FAD66).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF1FAD66).withOpacity(0.3)),
                          ),
                          child: Text(
                            c.objetivo,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1FAD66),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Action buttons
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_outlined, color: Colors.grey.shade700),
                        tooltip: "Editar cliente",
                        onPressed: () async {
                          final res = await showDialog<Cliente>(
                            context: context,
                            builder: (ctx) => ClienteDialog(editCliente: c),
                          );
                          if (res != null) {
                            await DatabaseHelper.instance.updateCliente(res.toMap(), c.id!);
                            widget.onReload();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.grey.shade700),
                        tooltip: "Excluir cliente",
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(
                                "Excluir Cliente",
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                              content: Text("Deseja realmente excluir o cliente ${c.nome}?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text("Cancelar"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text("Excluir"),
                                ),
                              ],
                            ),
                          );
                          
                          if (confirm == true) {
                            await DatabaseHelper.instance.deleteCliente(c.id!);
                            widget.onReload();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Message section if not empty
            if (c.mensagem.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.message_outlined, size: 16, color: Colors.grey.shade700),
                        const SizedBox(width: 8),
                        const Text(
                          "Mensagem",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        c.mensagem,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            
            // Projects section
            ExpansionTile(
              title: Row(
                children: [
                  const Icon(Icons.view_in_ar_outlined, size: 20),
                  const SizedBox(width: 10),
                  const Text(
                    "Projetos deste Cliente",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4475F2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      clientProjects.length.toString(),
                      style: const TextStyle(
                        color: Color(0xFF4475F2),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              initiallyExpanded: hasProjects,
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              childrenPadding: const EdgeInsets.only(bottom: 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasProjects)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: clientProjects.length,
                    itemBuilder: (context, index) {
                      final project = clientProjects[index];
                      return Container(
                        margin: EdgeInsets.only(
                          bottom: index < clientProjects.length - 1 ? 8 : 0,
                          left: 16,
                          right: 16,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1FAD66),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project.nome,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    project.dataCriacao != null 
                                      ? _formatDate(project.dataCriacao!)
                                      : "Data desconhecida",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.green.shade200),
                                  ),
                                  child: Text(
                                    "€${(project.precoVenda ?? 0).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Color(0xFF1FAD66),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Custo: €${project.custoTotal.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.view_in_ar_outlined,
                            size: 36,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Sem projetos associados",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // Summary section for projects
                if (hasProjects)
                  Container(
                    margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A3042).withOpacity(0.03),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Faturado",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "€${totalValue.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1FAD66),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.grey.shade300,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Lucro",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    "€${profit.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: profit >= 0 ? const Color(0xFF1FAD66) : Colors.red.shade700,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  if (totalCost > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: profit >= 0 ? const Color(0xFF1FAD66).withOpacity(0.1) : Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "${((profit / totalCost) * 100).toStringAsFixed(0)}%",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: profit >= 0 ? const Color(0xFF1FAD66) : Colors.red.shade700,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(icon, color: color, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40),
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            icon,
            size: 56,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600, 
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day/$month/${date.year}";
  }
}

// Enhanced ClienteDialog with modern UI
class ClienteDialog extends StatefulWidget {
  final Cliente? editCliente;
  const ClienteDialog({super.key, this.editCliente});
  
  @override
  State<ClienteDialog> createState() => _ClienteDialogState();
}

class _ClienteDialogState extends State<ClienteDialog> {
  final _formKey = GlobalKey<FormState>();
  late String nome;
  late String email;
  late String mensagem;
  late String objetivo;

  @override
  void initState() {
    super.initState();
    final c = widget.editCliente;
    nome = c?.nome ?? "";
    email = c?.email ?? "";
    mensagem = c?.mensagem ?? "";
    objetivo = c?.objetivo ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.editCliente != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dialog Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4475F2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? "Editar Cliente" : "Novo Cliente",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic info section
                      Text(
                        "Informações Básicas",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Name and email
                      TextFormField(
                        initialValue: nome,
                        decoration: const InputDecoration(
                          labelText: "Nome",
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) => v == null || v.isEmpty ? "Nome é obrigatório" : null,
                        onSaved: (v) => nome = v!,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: email,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (v) => v == null || v.isEmpty ? "Email é obrigatório" : null,
                        onSaved: (v) => email = v!,
                      ),
                      const SizedBox(height: 24),
                      
                      // Project info section
                      Text(
                        "Informações do Projeto",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        initialValue: objetivo,
                        decoration: const InputDecoration(
                          labelText: "Objetivo",
                          prefixIcon: Icon(Icons.assignment_outlined),
                        ),
                        validator: (v) => v == null || v.isEmpty ? "Objetivo é obrigatório" : null,
                        onSaved: (v) => objetivo = v!,
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        initialValue: mensagem,
                        decoration: const InputDecoration(
                          labelText: "Mensagem ou Notas",
                          prefixIcon: Icon(Icons.message_outlined),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                        onSaved: (v) => mensagem = v ?? "",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Dialog actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancelar", style: TextStyle(color: Colors.grey.shade700)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4475F2),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Navigator.pop(
                          context,
                          Cliente(
                            id: widget.editCliente?.id,
                            nome: nome,
                            email: email,
                            mensagem: mensagem,
                            objetivo: objetivo,
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.save_outlined, size: 18),
                        SizedBox(width: 8),
                        Text("Guardar", style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==== Enhanced AccountingPage (Contabilidade) ====
class AccountingPage extends StatefulWidget {
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
  State<AccountingPage> createState() => _AccountingPageState();
}

class _AccountingPageState extends State<AccountingPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Gasto> _filteredGastos = [];
  String _selectedPeriod = 'all'; // 'all', 'month', 'year'
  
  @override
  void initState() {
    super.initState();
    _filteredGastos = List.from(widget.gastos);
  }
  
  @override
  void didUpdateWidget(AccountingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gastos != widget.gastos) {
      _applyFilters();
    }
  }
  
  void _filterGastos(String query) {
    setState(() {
      _applyFilters(query);
    });
  }
  
  void _applyFilters([String? query]) {
    query ??= _searchController.text;
    DateTime now = DateTime.now();
    List<Gasto> filtered = List.from(widget.gastos);
    
    // Apply search filter
    if (query.isNotEmpty) {
      filtered = filtered.where((g) => 
        g.descricao.toLowerCase().contains(query!.toLowerCase())
      ).toList();
    }
    
    // Apply period filter
    if (_selectedPeriod == 'month') {
      filtered = filtered.where((g) => 
        g.data.year == now.year && g.data.month == now.month
      ).toList();
    } else if (_selectedPeriod == 'year') {
      filtered = filtered.where((g) => g.data.year == now.year).toList();
    }
    
    setState(() {
      _filteredGastos = filtered;
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate financial metrics
    double totalEnergia = widget.modelos.fold(0, (sum, m) => sum + m.energiaKwh);
    double custoEnergia = widget.modelos.fold(0, (sum, m) => sum + m.custoEnergia);
    double gastoFilamento = widget.modelos.fold(0, (sum, m) => sum + m.custoFilamento);
    double gastoAcessorios = widget.modelos.fold(0, (sum, m) => sum + m.custoAcessorios);
    double gastoOutros = widget.gastos.fold(0, (s, g) => s + g.valor);

    double ganhos = widget.modelos
        .where((m) => (m.clienteOuPessoal == "Cliente" || m.clienteId != null) && (m.precoVenda ?? 0) > 0)
        .fold(0.0, (sum, m) => sum + (m.precoVenda ?? 0));
    double custos = custoEnergia + gastoFilamento + gastoAcessorios + gastoOutros;
    double lucro = ganhos - custos;

    final gastosData = [
      PieChartSectionData(
        value: gastoFilamento,
        color: const Color(0xFF2A3042),
        title: "FLMTs",
        radius: 60,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        titlePositionPercentageOffset: 0.6,
      ),
      PieChartSectionData(
        value: gastoAcessorios,
        color: const Color(0xFF4475F2),
        title: "ACRs",
        radius: 60,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        titlePositionPercentageOffset: 0.6,
      ),
      PieChartSectionData(
        value: custoEnergia,
        color: const Color(0xFF1FAD66),
        title: "Energia",
        radius: 60,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        titlePositionPercentageOffset: 0.6,
      ),
      PieChartSectionData(
        value: gastoOutros,
        color: Colors.amber,
        title: "Outros",
        radius: 60,
        titleStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
        titlePositionPercentageOffset: 0.6,
      ),
    ].where((d) => d.value > 0).toList();

    final bool hasPieData = gastosData.isNotEmpty;

    // Current date and user info for display
    const currentDate = "2025-08-06 16:15:41";
    const currentUser = "Fsousa7";

    return Container(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          // Header with financial summary cards
          Row(
            children: [
              _buildFinancialCard(
                title: "Receita Total",
                value: ganhos,
                icon: Icons.monetization_on_outlined,
                color: const Color(0xFF1FAD66),
                subtitle: "${widget.modelos.length} modelos vendidos",
              ),
              const SizedBox(width: 16),
              _buildFinancialCard(
                title: "Custos Totais",
                value: custos,
                icon: Icons.account_balance_outlined,
                color: const Color(0xFF4475F2),
                subtitle: "Materiais, energia e outros",
              ),
              const SizedBox(width: 16),
              _buildFinancialCard(
                title: "Lucro Líquido",
                value: lucro,
                icon: Icons.trending_up,
                color: lucro >= 0 ? const Color(0xFF1FAD66) : Colors.red.shade700,
                subtitle: custos > 0 ? "Margem: ${((lucro / custos) * 100).toStringAsFixed(1)}%" : "",
                valueColor: lucro >= 0 ? const Color(0xFF1FAD66) : Colors.red.shade700,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Chart section
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A3042).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.pie_chart_outline, color: Color(0xFF2A3042)),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Distribuição dos Custos", 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 320,
                  child: hasPieData 
                    ? Row(
                        children: [
                          // Pie chart
                          Expanded(
                            flex: 3,
                            child: PieChart(
                              PieChartData(
                                sections: gastosData,
                                centerSpaceRadius: 50,
                                sectionsSpace: 4,
                                borderData: FlBorderData(show: false),
                              ),
                            ),
                          ),
                          // Legend
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLegendItem("Filamentos", const Color(0xFF2A3042), "€${gastoFilamento.toStringAsFixed(2)}"),
                                  const SizedBox(height: 16),
                                  _buildLegendItem("Acessórios", const Color(0xFF4475F2), "€${gastoAcessorios.toStringAsFixed(2)}"),
                                  const SizedBox(height: 16),
                                  _buildLegendItem("Energia", const Color(0xFF1FAD66), "€${custoEnergia.toStringAsFixed(2)}"),
                                  const SizedBox(height: 16),
                                  _buildLegendItem("Outros", Colors.amber, "€${gastoOutros.toStringAsFixed(2)}"),
                                  const SizedBox(height: 24),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2A3042).withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Total",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "€${custos.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bar_chart, size: 56, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              "Dados insuficientes para gerar o gráfico",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Detailed stats section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4475F2).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.inventory_2_outlined,
                                color: Color(0xFF4475F2),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Materiais",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildStatRow(
                          "Filamentos em Stock",
                          widget.filamentos.length.toString(),
                        ),
                        _buildStatRow(
                          "Acessórios em Stock",
                          widget.acessorios.length.toString(),
                        ),
                        _buildStatRow(
                          "Valor Total em Inventário",
                          "€${_calculateInventoryValue().toStringAsFixed(2)}",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1FAD66).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.bolt_outlined,
                                color: Color(0xFF1FAD66),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Consumo",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildStatRow(
                          "Energia Consumida",
                          "${totalEnergia.toStringAsFixed(2)} kWh",
                        ),
                        _buildStatRow(
                          "Custo de Energia",
                          "€${custoEnergia.toStringAsFixed(2)}",
                        ),
                        _buildStatRow(
                          "Tempo Total de Impressão",
                          _formatTotalTime(widget.modelos.fold(0, (sum, m) => sum + m.tempoMinutos)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Expenses section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Lançamentos de Gastos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  // Period filter
                  ChoiceChip(
                    label: const Text("Todos"),
                    selected: _selectedPeriod == 'all',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedPeriod = 'all';
                          _applyFilters();
                        });
                      }
                    },
                    selectedColor: const Color(0xFF4475F2).withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: _selectedPeriod == 'all' ? const Color(0xFF4475F2) : Colors.grey.shade800,
                      fontWeight: _selectedPeriod == 'all' ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text("Este Mês"),
                    selected: _selectedPeriod == 'month',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedPeriod = 'month';
                          _applyFilters();
                        });
                      }
                    },
                    selectedColor: const Color(0xFF4475F2).withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: _selectedPeriod == 'month' ? const Color(0xFF4475F2) : Colors.grey.shade800,
                      fontWeight: _selectedPeriod == 'month' ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text("Este Ano"),
                    selected: _selectedPeriod == 'year',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedPeriod = 'year';
                          _applyFilters();
                        });
                      }
                    },
                    selectedColor: const Color(0xFF4475F2).withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: _selectedPeriod == 'year' ? const Color(0xFF4475F2) : Colors.grey.shade800,
                      fontWeight: _selectedPeriod == 'year' ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Search bar for expenses
          searchBar(
            hint: "Pesquisar lançamentos por descrição...",
            controller: _searchController,
            onChanged: _filterGastos,
            onClear: () {
              _searchController.clear();
              _filterGastos('');
            },
          ),
          
          if (_filteredGastos.isEmpty && widget.gastos.isNotEmpty)
            _buildEmptyState("Nenhum lançamento encontrado com os filtros atuais.", Icons.search_off),
          if (_filteredGastos.isEmpty && widget.gastos.isEmpty)
            _buildEmptyState("Nenhum lançamento de gastos registrado.", Icons.account_balance_wallet_outlined),
            
          // List of expenses
          ..._filteredGastos.map((g) => _buildExpenseCard(g)),
          
          const SizedBox(height: 24),
          
          // System info footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "© 2025 SKYPT - Sistema de Gestão para Impressão 3D",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  "Sessão: $currentUser | $currentDate",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard({
    required String title,
    required double value,
    required IconData icon,
    required Color color,
    String subtitle = "",
    Color? valueColor,
  }) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(icon, color: color, size: 28),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "€${value.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: valueColor,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseCard(Gasto g) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.red.shade700, width: 4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Icon(
                    Icons.trending_down,
                    color: Colors.red.shade700,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      g.descricao,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(g.data),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Text(
                  "€${g.valor.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.red.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String value) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32),
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600, 
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day/$month/${date.year}";
  }
  
  String _formatTotalTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    
    return "$hours h $mins min";
  }
  
  double _calculateInventoryValue() {
    double filamentosValue = widget.filamentos.fold(
      0.0, 
      (sum, f) => sum + (f.precoCompra * f.stockAtual / f.gramas)
    );
    
    double acessoriosValue = widget.acessorios.fold(
      0.0, 
      (sum, a) => sum + (a.precoCompra * a.quantidade)
    );
    
    return filamentosValue + acessoriosValue;
  }
}

// ==== Enhanced SettingsPage ====
class SettingsPage extends StatelessWidget {
  final int userId;
  final double precoKwhUser;
  final List<Impressora> impressoras;
  final VoidCallback onReload;
  final VoidCallback onEditarPrecoKwh;
  final Future<void> Function(Impressora, bool) onManageImpressora;

  const SettingsPage({
    super.key,
    required this.userId,
    required this.precoKwhUser,
    required this.impressoras,
    required this.onEditarPrecoKwh,
    required this.onReload,
    required this.onManageImpressora,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column - System settings
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Energy configuration section
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            title: "Configuração de Energia",
                            icon: Icons.bolt_outlined,
                            color: const Color(0xFF4475F2),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Preço da luz atual",
                                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "€${precoKwhUser.toStringAsFixed(3)} por kWh",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2A3042),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4475F2),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    ),
                                    onPressed: onEditarPrecoKwh,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.edit_outlined, size: 18),
                                        SizedBox(width: 8),
                                        Text("Alterar", style: TextStyle(fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Printers section
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            title: "Gestão de Impressoras",
                            icon: Icons.print_outlined,
                            color: const Color(0xFF1FAD66),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                ...impressoras.map((imp) => _buildPrinterCard(imp, context)),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1FAD66),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    onPressed: () async {
                                      final res = await showDialog<Impressora>(
                                        context: context,
                                        builder: (ctx) => const ImpressoraDialog(),
                                      );
                                      if (res != null) {
                                        await onManageImpressora(res, false);
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.add, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          "Adicionar Impressora",
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 24),
              
              // Right column - System info
                            // Right column - System info
              Expanded(
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        title: "Informações do Sistema",
                        icon: Icons.info_outline,
                        color: const Color(0xFF2A3042),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A3042),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.view_in_ar_rounded,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "SKYPT",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: Color(0xFF2A3042),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Sistema de Gestão para Impressão 3D",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF4475F2),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildSystemInfoRow(
                              "Versão", 
                              "1.1.0",
                              icon: Icons.new_releases_outlined
                            ),
                            const Divider(height: 32),
                            _buildSystemInfoRow(
                              "Data de Atualização", 
                              "2025-08-06 16:19:55",
                              icon: Icons.update
                            ),
                            const Divider(height: 32),
                            _buildSystemInfoRow(
                              "Usuário Atual", 
                              "Fsousa7",
                              icon: Icons.person_outline
                            ),
                            const Divider(height: 32),
                            _buildSystemInfoRow(
                              "ID do Usuário", 
                              userId.toString(),
                              icon: Icons.badge_outlined
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade100,
                                foregroundColor: Colors.grey.shade700,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AboutDialog(
                                    applicationName: 'SKYPT - Gestão 3D',
                                    applicationVersion: '1.1.0',
                                    applicationIcon: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2A3042),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.view_in_ar_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    children: const [
                                      SizedBox(height: 16),
                                      Text(
                                        'Sistema avançado para gestão de impressoras 3D, filamentos, clientes, e contabilidade.',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Desenvolvido com Flutter. © 2025 SKYPT. Todos os direitos reservados.',
                                        style: TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.info_outline, size: 18, color: Colors.grey.shade700),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Sobre o Sistema",
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrinterCard(Impressora impressora, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1FAD66).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.print_outlined,
              color: Color(0xFF1FAD66),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  impressora.nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Potência: ${(impressora.potenciaKw * 1000).toStringAsFixed(0)}W",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                color: Colors.grey.shade700,
                tooltip: "Editar impressora",
                onPressed: () async {
                  final res = await showDialog<Impressora>(
                    context: context,
                    builder: (ctx) => ImpressoraDialog(editImpressora: impressora),
                  );
                  if (res != null) {
                    await onManageImpressora(res, false);
                  }
                },
              ),
              if (impressoras.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.grey.shade700,
                  tooltip: "Excluir impressora",
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(
                          "Excluir Impressora",
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                        content: Text("Deseja realmente excluir a impressora ${impressora.nome}?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text("Excluir"),
                          ),
                        ],
                      ),
                    );
                    
                    if (confirm == true) {
                      await onManageImpressora(impressora, true);
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSystemInfoRow(String label, String value, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 12),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2A3042),
          ),
        ),
      ],
    );
  }
}

// ==== Enhanced ImpressoraDialog (Printer Dialog) ====
class ImpressoraDialog extends StatefulWidget {
  final Impressora? editImpressora;
  
  const ImpressoraDialog({
    super.key,
    this.editImpressora,
  });

  @override
  State<ImpressoraDialog> createState() => _ImpressoraDialogState();
}

class _ImpressoraDialogState extends State<ImpressoraDialog> {
  final _formKey = GlobalKey<FormState>();
  late String nome;
  late double potenciaKw;
  
  @override
  void initState() {
    super.initState();
    final i = widget.editImpressora;
    nome = i?.nome ?? "";
    potenciaKw = i?.potenciaKw ?? 0.13; // Default 130W
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.editImpressora != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dialog Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1FAD66),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.print_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  isEditing ? "Editar Impressora" : "Nova Impressora",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Form Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: nome,
                    decoration: const InputDecoration(
                      labelText: "Nome da Impressora",
                      prefixIcon: Icon(Icons.print_outlined),
                    ),
                    validator: (v) => v == null || v.isEmpty ? "Nome é obrigatório" : null,
                    onSaved: (v) => nome = v!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: (potenciaKw * 1000).toStringAsFixed(0),
                    decoration: const InputDecoration(
                      labelText: "Potência (W)",
                      prefixIcon: Icon(Icons.bolt_outlined),
                      helperText: "Ex: 130 para 130W",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || double.tryParse(v) == null ? "Insira um número válido" : null,
                    onSaved: (v) => potenciaKw = (double.parse(v!) / 1000),
                  ),
                ],
              ),
            ),
          ),
          
          // Dialog actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar", style: TextStyle(color: Colors.grey.shade700)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1FAD66),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.pop(
                        context,
                        Impressora(
                          id: widget.editImpressora?.id,
                          nome: nome,
                          potenciaKw: potenciaKw,
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.save_outlined, size: 18),
                      SizedBox(width: 8),
                      Text("Guardar", style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}