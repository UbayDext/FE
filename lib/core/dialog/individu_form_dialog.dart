import 'package:attandance_simple/core/models/individu/get_individu_public/datum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attandance_simple/core/cubit/cubit_individu_status/individu_status_cubit.dart';

class IndividuFormDialog extends StatefulWidget {
  final Datum? lomba;
  final int ekskulId;
  final int lombadId;
  const IndividuFormDialog({super.key, this.lomba, required this.ekskulId, required this.lombadId});

  @override
  State<IndividuFormDialog> createState() => _IndividuFormDialogState();
}

class _IndividuFormDialogState extends State<IndividuFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _roundCtrl;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _statusRound;

  @override
  void initState() {
    super.initState();
    _roundCtrl = TextEditingController(text: widget.lomba?.nameLomba ?? '');
    _statusRound = widget.lomba?.status?.toLowerCase();

    if (widget.lomba?.startDate != null) {
      _startDate = DateFormat('yyyy-MM-dd').parse(widget.lomba!.startDate!);
    }
    if (widget.lomba?.endDate != null) {
      _endDate = DateFormat('yyyy-MM-dd').parse(widget.lomba!.endDate!);
    }
  }

  @override
  void dispose() {
    _roundCtrl.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) => DateFormat('yyyy-MM-dd').format(d);
  String _disp(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(widget.lomba == null ? 'Tambah Babak' : 'Edit Babak'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _roundCtrl,
                decoration: InputDecoration(
                  labelText: 'Nama Babak',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Nama babak harus diisi' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(_startDate == null ? 'Pilih Tanggal Mulai' : 'Mulai: ${_disp(_startDate!)}'),
                trailing: const Icon(Icons.date_range),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _startDate = picked);
                },
              ),
              ListTile(
                title: Text(_endDate == null ? 'Pilih Tanggal Selesai' : 'Selesai: ${_disp(_endDate!)}'),
                trailing: const Icon(Icons.date_range),
                onTap: () async {
                  if (_startDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Silakan pilih tanggal mulai terlebih dahulu.'), backgroundColor: Colors.orange),
                    );
                    return;
                  }
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: (_endDate != null && _endDate!.isAfter(_startDate!)) ? _endDate! : _startDate!,
                    firstDate: _startDate!,
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _endDate = picked);
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _statusRound,
                hint: const Text('Pilih Status'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'berlangsung', child: Text('Berlangsung')),
                  DropdownMenuItem(value: 'selesai', child: Text('Selesai')),
                ],
                onChanged: (v) => setState(() => _statusRound = v),
                validator: (v) => v == null ? 'Status harus dipilih' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        TextButton(
          child: Text(widget.lomba == null ? 'Simpan' : 'Update'),
          onPressed: () {
            if (!_formKey.currentState!.validate() || _startDate == null || _endDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Semua field harus diisi!'), backgroundColor: Colors.red),
              );
              return;
            }
            final c = context.read<IndividuStatusCubit>();
            if (widget.lomba == null) {
              c.addIndividuLomba(
                nameLomba: _roundCtrl.text,
                ekskulId: widget.ekskulId,
                startDate: _fmt(_startDate!),
                endDate: _fmt(_endDate!),
                status: _statusRound!, // boleh lowercase
                lombaId: widget.lombadId,
              );
            } else {
              c.editIndividuLomba(
                id: widget.lomba!.id!,
                nameLomba: _roundCtrl.text,
                ekskulId: widget.ekskulId,
                startDate: _fmt(_startDate!),
                endDate: _fmt(_endDate!),
                status: _statusRound!,
                lombaId: widget.lombadId,
              );
            }
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
