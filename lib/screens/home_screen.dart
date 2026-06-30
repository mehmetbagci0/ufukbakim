import 'package:flutter/material.dart';

import '../models/building.dart';
import '../models/maintenance_group.dart';
import '../services/app_state.dart';
import 'building_detail_screen.dart';
import 'building_form_screen.dart';
import 'group_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.appState});

  final AppState appState;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Ufuk Asansör Bakım'),
          ),
          body: _tabIndex == 0 ? _buildingsTab() : _groupsTab(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _tabIndex == 0 ? _addBuilding : _addGroup,
            icon: const Icon(Icons.add),
            label: Text(_tabIndex == 0 ? 'Bina Ekle' : 'Grup Ekle'),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _tabIndex,
            onDestinationSelected: (index) => setState(() => _tabIndex = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.location_city_outlined),
                label: 'Binalar',
              ),
              NavigationDestination(
                icon: Icon(Icons.groups_outlined),
                label: 'Gruplar',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildingsTab() {
    final appState = widget.appState;
    final groups = appState.groups;
    final buildings = appState.filteredBuildings;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: DropdownButtonFormField<String?>(
            value: appState.selectedGroupId,
            decoration: const InputDecoration(
              labelText: 'Grup filtrele',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('Tüm Gruplar'),
              ),
              ...groups.map(
                (group) => DropdownMenuItem<String?>(
                  value: group.id,
                  child: Text(
                    '${group.name} (${appState.buildingCountForGroup(group.id)})',
                  ),
                ),
              ),
            ],
            onChanged: appState.setSelectedGroup,
          ),
        ),
        Expanded(
          child: buildings.isEmpty
              ? const Center(
                  child: Text('Bu filtrede bina yok. Yeni bina ekleyin.'),
                )
              : ListView.separated(
                  itemCount: buildings.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final building = buildings[index];
                    final groupName = appState.groupNameById(building.groupId) ?? '-';

                    return ListTile(
                      title: Text(building.name),
                      subtitle: Text('$groupName • ${building.district}/${building.city}'),
                      onTap: () => _openBuildingDetail(building),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editBuilding(building);
                          } else if (value == 'delete') {
                            appState.deleteBuilding(building.id);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('Düzenle')),
                          PopupMenuItem(value: 'delete', child: Text('Sil')),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _groupsTab() {
    final appState = widget.appState;
    final groups = appState.groups;

    if (groups.isEmpty) {
      return const Center(child: Text('Henüz grup yok. Önce grup ekleyin.'));
    }

    return ListView.separated(
      itemCount: groups.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final group = groups[index];
        final count = appState.buildingCountForGroup(group.id);

        return ListTile(
          title: Text(group.name),
          subtitle: Text('$count bina'),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _editGroup(group);
              } else if (value == 'delete') {
                final success = appState.deleteGroup(group.id);
                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bu grupta bina olduğu için grup silinemez.'),
                    ),
                  );
                }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Düzenle')),
              PopupMenuItem(value: 'delete', child: Text('Sil')),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addGroup() async {
    final name = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const GroupFormScreen()),
    );

    if (name == null || name.isEmpty) return;
    widget.appState.addGroup(name);
  }

  Future<void> _editGroup(MaintenanceGroup group) async {
    final name = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => GroupFormScreen(initialName: group.name)),
    );

    if (name == null || name.isEmpty) return;
    widget.appState.updateGroup(group.id, name);
  }

  Future<void> _addBuilding() async {
    final appState = widget.appState;

    if (appState.groups.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Önce en az bir grup ekleyin.')),
      );
      return;
    }

    final building = await Navigator.of(context).push<Building>(
      MaterialPageRoute(
        builder: (_) => BuildingFormScreen(
          groups: appState.groups,
          initialGroupId: appState.selectedGroupId,
        ),
      ),
    );

    if (building == null) return;
    appState.addBuilding(building);
  }

  Future<void> _editBuilding(Building building) async {
    final appState = widget.appState;

    final updated = await Navigator.of(context).push<Building>(
      MaterialPageRoute(
        builder: (_) => BuildingFormScreen(
          groups: appState.groups,
          initialValue: building,
        ),
      ),
    );

    if (updated == null) return;
    appState.updateBuilding(building.id, updated);
  }

  void _openBuildingDetail(Building building) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BuildingDetailScreen(
          appState: widget.appState,
          building: building,
        ),
      ),
    );
  }
}
