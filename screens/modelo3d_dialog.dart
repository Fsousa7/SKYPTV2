import 'package:flutter/material.dart';
import 'blank_screen.dart'; // Importa os modelos

class Modelo3DDialog extends StatefulWidget {
  final Modelo3D? editModelo;
  final List<Filamento> filamentos;
  final List<Acessorio> acessorios;
  final List<Cliente> clientes;
  final List<Impressora> impressoras;
  final double precoKwhUser;

  const Modelo3DDialog({
    super.key,
    this.editModelo,
    required this.filamentos,
    required this.acessorios,
    required this.clientes,
    required this.impressoras,
    required this.precoKwhUser,
  });

  @override
  State<Modelo3DDialog> createState() => _Modelo3DDialogState();
}

class _Modelo3DDialogState extends State<Modelo3DDialog> {
  final _formKey = GlobalKey<FormState>();
  late String nome;
  late int tempoMinutos;
  late String clienteOuPessoal;
  int? clienteId;
  double? precoVenda;
  int? impressoraId;

  List<FilamentoUsado> filamentosUsados = [];
  List<Map<String, dynamic>> filamentoInputs = [];
  Map<int, bool> acessorioSelecionado = {};
  Map<int, int> acessorioQtd = {};

  TextEditingController _clienteSearchController = TextEditingController();
  TextEditingController _tempoMinutosController = TextEditingController();
  List<Cliente> _filteredClientes = [];

  double custoFilamento = 0;
  double custoAcessorios = 0;
  double energiaKwh = 0;
  double custoEnergia = 0;
  double custoTotal = 0;

  @override
  void initState() {
    super.initState();
    final m = widget.editModelo;
    nome = m?.nome ?? "";
    tempoMinutos = m?.tempoMinutos ?? 0;
    _tempoMinutosController.text = tempoMinutos > 0 ? tempoMinutos.toString() : '';
    clienteOuPessoal = m?.clienteOuPessoal ?? "Pessoal";
    clienteId = m?.clienteId;
    precoVenda = m?.precoVenda;
    impressoraId = m?.impressoraId ?? (widget.impressoras.isNotEmpty ? widget.impressoras.first.id : null);

    // Filamentos usados inicialização
    if (m?.filamentosUsados != null && m!.filamentosUsados.isNotEmpty) {
      filamentosUsados = List.from(m.filamentosUsados);
      filamentoInputs = filamentosUsados.map((f) => {
        'filamentoId': f.filamentoId,
        'gramasUsados': f.gramasUsados
      }).toList();
    } else {
      filamentoInputs = [
        {
          'filamentoId': widget.filamentos.isNotEmpty ? widget.filamentos.first.id! : 0,
          'gramasUsados': 0,
        }
      ];
    }

    // Acessórios
    if (m?.acessoriosUsados != null && m!.acessoriosUsados.isNotEmpty) {
      final lista = m.acessoriosUsados.split(',');
      for (var acc in lista) {
        final parts = acc.split(':');
        if (parts.length == 2) {
          final nome = parts[0];
          final qtd = int.tryParse(parts[1]) ?? 0;
          final idAcc = widget.acessorios.firstWhere((a) => a.nome == nome, orElse: () => Acessorio(id: -1, nome: '', quantidade: 0, precoCompra: 0)).id;
          if (idAcc != null && idAcc > 0) {
            acessorioSelecionado[idAcc] = true;
            acessorioQtd[idAcc] = qtd;
          }
        }
      }
    } else {
      for (var a in widget.acessorios) {
        acessorioSelecionado[a.id!] = false;
        acessorioQtd[a.id!] = 0;
      }
    }

    _filteredClientes = List.from(widget.clientes);
  }

  void calcularCustos() {
    // Filamentos
    custoFilamento = 0;
    filamentosUsados.clear();
    for (var input in filamentoInputs) {
      final f = widget.filamentos.firstWhere((fil) => fil.id == input['filamentoId']);
      int gramas = input['gramasUsados'] ?? 0;
      if (f.id != null && gramas > 0) {
        double custo = gramas * (f.precoCompra / f.gramas);
        custoFilamento += custo;
        filamentosUsados.add(FilamentoUsado(
          filamentoId: f.id!,
          cor: f.cor,
          fabricante: f.fabricante,
          gramasUsados: gramas,
          custo: custo,
        ));
      }
    }

    // Acessórios
    custoAcessorios = 0;
    acessorioSelecionado.forEach((id, sel) {
      if (sel && acessorioQtd[id]! > 0) {
        final acc = widget.acessorios.firstWhere((a) => a.id == id);
        custoAcessorios += acc.precoCompra * acessorioQtd[id]!;
      }
    });

    // Impressora/energia
    final impressora = widget.impressoras.firstWhere((i) => i.id == impressoraId, orElse: () => widget.impressoras.first);
    energiaKwh = impressora.potenciaKw * (tempoMinutos / 60.0);
    custoEnergia = energiaKwh * widget.precoKwhUser;

    custoTotal = custoFilamento + custoAcessorios + custoEnergia;
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
                c.objetivo.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _clienteSearchController.dispose();
    _tempoMinutosController.dispose();
    super.dispose();
  }

  void _onTempoMinutosChanged(String value) {
    tempoMinutos = int.tryParse(value) ?? 0;
    setState(() {
      calcularCustos();
    });
  }

  void _onFilamentoChanged(int i, String value) {
    filamentoInputs[i]['gramasUsados'] = int.tryParse(value) ?? 0;
    setState(() {
      calcularCustos();
    });
  }

  void _onAcessorioQtdChanged(int id, String value) {
    acessorioQtd[id] = int.tryParse(value) ?? 0;
    setState(() {
      calcularCustos();
    });
  }

  void _onAcessorioSelecionadoChanged(int id, bool value) {
    acessorioSelecionado[id] = value;
    if (!value) acessorioQtd[id] = 0;
    setState(() {
      calcularCustos();
    });
  }

  @override
  Widget build(BuildContext context) {
    calcularCustos();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
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
                      Icons.view_in_ar_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.editModelo == null ? "Novo Modelo 3D" : "Editar Modelo 3D",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: nome,
                        decoration: const InputDecoration(
                          labelText: "Nome do Modelo",
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (v) => v == null || v.isEmpty ? "Obrigatório" : null,
                        onSaved: (v) => nome = v ?? "",
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _tempoMinutosController,
                        decoration: const InputDecoration(
                          labelText: "Tempo de Impressão (minutos)",
                          prefixIcon: Icon(Icons.timer_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || int.tryParse(v) == null || int.parse(v) <= 0 ? "Obrigatório" : null,
                        onChanged: _onTempoMinutosChanged,
                        onSaved: (v) => tempoMinutos = int.parse(v ?? "0"),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: "Impressora",
                          prefixIcon: Icon(Icons.print_outlined),
                        ),
                        value: impressoraId,
                        items: widget.impressoras.map((i) => DropdownMenuItem(
                          value: i.id,
                          child: Text(i.nome),
                        )).toList(),
                        onChanged: (v) => setState(() {
                          impressoraId = v;
                          calcularCustos();
                        }),
                        validator: (v) => v == null ? "Obrigatório" : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Tipo de Projeto",
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        value: clienteOuPessoal,
                        items: const [
                          DropdownMenuItem(value: "Pessoal", child: Text("Pessoal")),
                          DropdownMenuItem(value: "Cliente", child: Text("Cliente")),
                        ],
                        onChanged: (v) => setState(() => clienteOuPessoal = v ?? "Pessoal"),
                      ),
                      const SizedBox(height: 16),
                      // Cliente com busca
                      if (clienteOuPessoal == "Cliente") ...[
                        TextFormField(
                          controller: _clienteSearchController,
                          decoration: const InputDecoration(
                            labelText: "Pesquisar Cliente...",
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: _filterClientes,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: "Cliente",
                            prefixIcon: Icon(Icons.people_outline),
                          ),
                          value: clienteId,
                          items: _filteredClientes.map((c) =>
                            DropdownMenuItem(
                              value: c.id,
                              child: Text("${c.nome} - ${c.email}"),
                            )
                          ).toList(),
                          onChanged: (v) => setState(() => clienteId = v),
                          validator: (v) => v == null ? "Selecione um cliente" : null,
                        ),
                        const SizedBox(height: 16),
                      ],

                      // FILAMENTOS USADOS
                      Text("Filamentos utilizados:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800])),
                      Column(
                        children: [
                          for (int i = 0; i < filamentoInputs.length; i++)
                            Card(
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: DropdownButtonFormField<int>(
                                        value: filamentoInputs[i]['filamentoId'],
                                        decoration: const InputDecoration(
                                          labelText: "Filamento",
                                          isDense: true,
                                        ),
                                        items: widget.filamentos.map((f) =>
                                          DropdownMenuItem(
                                            value: f.id!,
                                            child: Text("${f.fabricante} - ${f.cor}"),
                                          )
                                        ).toList(),
                                        onChanged: (v) {
                                          setState(() {
                                            filamentoInputs[i]['filamentoId'] = v!;
                                            calcularCustos();
                                          });
                                        },
                                        validator: (v) => v == null ? "Obrigatório" : null,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      flex: 2,
                                      child: TextFormField(
                                        initialValue: filamentoInputs[i]['gramasUsados'] != null && filamentoInputs[i]['gramasUsados'] > 0 ? filamentoInputs[i]['gramasUsados'].toString() : "",
                                        decoration: const InputDecoration(
                                          labelText: "Gramas",
                                          isDense: true,
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (v) => _onFilamentoChanged(i, v),
                                        validator: (v) {
                                          if (v == null || int.tryParse(v) == null || int.parse(v) <= 0) return "Obrigatório";
                                          return null;
                                        },
                                      ),
                                    ),
                                    if (filamentoInputs.length > 1)
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                                        tooltip: "Remover filamento",
                                        onPressed: () {
                                          setState(() {
                                            filamentoInputs.removeAt(i);
                                            calcularCustos();
                                          });
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text("Adicionar filamento"),
                              onPressed: () {
                                setState(() {
                                  filamentoInputs.add({
                                    'filamentoId': widget.filamentos.isNotEmpty ? widget.filamentos.first.id! : 0,
                                    'gramasUsados': 0,
                                  });
                                  calcularCustos();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Acessórios usados (multi-select)
                      if (widget.acessorios.isNotEmpty) ...[
                        Text("Acessórios utilizados:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800])),
                        ...widget.acessorios.map((a) => Row(
                          children: [
                            Checkbox(
                              value: acessorioSelecionado[a.id!] ?? false,
                              onChanged: (v) => _onAcessorioSelecionadoChanged(a.id!, v!),
                            ),
                            Expanded(child: Text("${a.nome}")),
                            SizedBox(
                              width: 70,
                              child: TextFormField(
                                enabled: acessorioSelecionado[a.id!] ?? false,
                                initialValue: acessorioQtd[a.id!] != null && acessorioQtd[a.id!]! > 0 ? acessorioQtd[a.id!].toString() : "",
                                decoration: const InputDecoration(
                                  labelText: "Qtd",
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (v) => _onAcessorioQtdChanged(a.id!, v),
                                validator: (v) {
                                  if (acessorioSelecionado[a.id!] == true) {
                                    if (v == null || int.tryParse(v) == null || int.parse(v) <= 0) return "Obrigatório";
                                  }
                                  return null;
                                },
                              ),
                            )
                          ],
                        )),
                        const SizedBox(height: 16),
                      ],

                      TextFormField(
                        initialValue: precoVenda != null ? precoVenda!.toStringAsFixed(2) : "",
                        decoration: const InputDecoration(
                          labelText: "Preço de Venda (opcional)",
                          prefixIcon: Icon(Icons.euro),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onSaved: (v) => precoVenda = double.tryParse(v?.replaceAll(',', '.') ?? ""),
                      ),
                      const SizedBox(height: 24),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Resumo de custos:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800])),
                            Text("Filamentos: €${custoFilamento.toStringAsFixed(2)}"),
                            Text("Acessórios: €${custoAcessorios.toStringAsFixed(2)}"),
                            Text("Energia: €${custoEnergia.toStringAsFixed(2)} (${energiaKwh.toStringAsFixed(2)} kWh)"),
                            const Divider(),
                            Text("Total: €${custoTotal.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                        calcularCustos();
                        String acessoriosUsadosStr = '';
                        acessorioSelecionado.forEach((id, sel) {
                          if (sel && acessorioQtd[id]! > 0) {
                            final acc = widget.acessorios.firstWhere((a) => a.id == id);
                            acessoriosUsadosStr += "${acc.nome}:${acessorioQtd[id]},";
                          }
                        });
                        Navigator.pop(
                          context,
                          Modelo3D(
                            nome: nome,
                            filamentosUsados: filamentosUsados,
                            tempoMinutos: tempoMinutos,
                            clienteOuPessoal: clienteOuPessoal,
                            clienteId: clienteId,
                            clienteNome: clienteId != null
                              ? widget.clientes.firstWhere((c) => c.id == clienteId).nome
                              : null,
                            energiaKwh: energiaKwh,
                            custoEnergia: custoEnergia,
                            custoFilamento: custoFilamento,
                            custoAcessorios: custoAcessorios,
                            custoTotal: custoTotal,
                            acessoriosUsados: acessoriosUsadosStr,
                            precoVenda: precoVenda,
                            dataCriacao: DateTime.now(),
                            impressoraId: impressoraId,
                            impressoraNome: impressoraId != null
                              ? widget.impressoras.firstWhere((i) => i.id == impressoraId).nome
                              : null,
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