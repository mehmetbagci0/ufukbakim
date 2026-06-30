import 'package:flutter/material.dart';

import '../models/building.dart';
import '../models/maintenance_group.dart';

class BuildingFormScreen extends StatefulWidget {
  const BuildingFormScreen({
    super.key,
    required this.groups,
    this.initialValue,
    this.initialGroupId,
  });

  final List<MaintenanceGroup> groups;
  final Building? initialValue;
  final String? initialGroupId;

  @override
  State<BuildingFormScreen> createState() => _BuildingFormScreenState();
}

class _BuildingFormScreenState extends State<BuildingFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _districtController;
  late final TextEditingController _neighborhoodController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _phoneController;
  late final TextEditingController _notesController;

  String? _selectedGroupId;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialValue;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _addressController = TextEditingController(text: initial?.address ?? '');
    _cityController = TextEditingController(text: initial?.city ?? '');
    _districtController = TextEditingController(text: initial?.district ?? '');
    _neighborhoodController = TextEditingController(text: initial?.neighborhood ?? '');
    _latitudeController = TextEditingController(
      text: initial?.latitude != null ? initial!.latitude.toString() : '',
    );
    _longitudeController = TextEditingController(
      text: initial?.longitude != null ? initial!.longitude.toString() : '',
    );
    _phoneController = TextEditingController(text: initial?.contactPhone ?? '');
    _notesController = TextEditingController(text: initial?.notes ?? '');

    _selectedGroupId =
        initial?.groupId ??
        widget.initialGroupId ??
        (widget.groups.isNotEmpty ? widget.groups.first.id : null);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _neighborhoodController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialValue != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Bina Düzenle' : 'Yeni Bina')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_nameController, 'Bina adı *'),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedGroupId,
              decoration: const InputDecoration(
                labelText: 'Grup *',
                border: OutlineInputBorder(),
              ),
              items: widget.groups
                  .map(
                    (group) => DropdownMenuItem(
                      value: group.id,
                      child: Text(group.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedGroupId = value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Grup seçmek zorunludur';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _field(_addressController, 'Adres *', maxLines: 2),
            const SizedBox(height: 12),
            _field(_cityController, 'İl *'),
            const SizedBox(height: 12),
            _field(_districtController, 'İlçe *'),
            const SizedBox(height: 12),
            _field(_neighborhoodController, 'Mahalle'),
            const SizedBox(height: 12),
            _field(
              _latitudeController,
              'Enlem',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            _field(
              _longitudeController,
              'Boylam',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            _field(
              _phoneController,
              'Yetkili telefon',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _field(_notesController, 'Notlar', maxLines: 3),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _save,
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (label.contains('*') && (value == null || value.trim().isEmpty)) {
          return 'Bu alan zorunludur';
        }
        return null;
      },
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final building = Building(
      id: widget.initialValue?.id ?? '',
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      district: _districtController.text.trim(),
      groupId: _selectedGroupId!,
      neighborhood: _nullableText(_neighborhoodController.text),
      latitude: _parseNullableDouble(_latitudeController.text),
      longitude: _parseNullableDouble(_longitudeController.text),
      contactPhone: _nullableText(_phoneController.text),
      notes: _nullableText(_notesController.text),
    );

    Navigator.of(context).pop(building);
  }

  String? _nullableText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  double? _parseNullableDouble(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed.replaceAll(',', '.'));
  }
}
