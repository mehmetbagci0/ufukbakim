import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/building.dart';
import '../services/app_state.dart';

class BuildingDetailScreen extends StatelessWidget {
  const BuildingDetailScreen({
    super.key,
    required this.appState,
    required this.building,
  });

  final AppState appState;
  final Building building;

  @override
  Widget build(BuildContext context) {
    final groupName = appState.groupNameById(building.groupId) ?? '-';

    return Scaffold(
      appBar: AppBar(title: Text(building.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _item('Grup', groupName),
          _item('Adres', building.address),
          _item('İl', building.city),
          _item('İlçe', building.district),
          _item('Mahalle', building.neighborhood ?? '-'),
          _item(
            'Konum',
            building.latitude != null && building.longitude != null
                ? '${building.latitude}, ${building.longitude}'
                : '-',
          ),
          _item('Telefon', building.contactPhone ?? '-'),
          _item('Notlar', building.notes ?? '-'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _openMaps(context),
            icon: const Icon(Icons.map_outlined),
            label: const Text('Google Maps’te Aç'),
          ),
        ],
      ),
    );
  }

  Widget _item(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }

  Future<void> _openMaps(BuildContext context) async {
    final url = appState.mapsUrlForBuilding(building);
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Maps açılamadı.')),
      );
    }
  }
}
