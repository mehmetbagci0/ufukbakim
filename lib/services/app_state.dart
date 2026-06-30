import 'package:flutter/foundation.dart';

import '../models/building.dart';
import '../models/maintenance_group.dart';

class AppState extends ChangeNotifier {
  final List<MaintenanceGroup> _groups = [];
  final List<Building> _buildings = [];

  int _idCounter = 0;
  String? selectedGroupId;

  List<MaintenanceGroup> get groups => List.unmodifiable(_groups);
  List<Building> get buildings => List.unmodifiable(_buildings);

  List<Building> get filteredBuildings {
    if (selectedGroupId == null) {
      return buildings;
    }
    return _buildings.where((b) => b.groupId == selectedGroupId).toList();
  }

  String? groupNameById(String groupId) {
    for (final group in _groups) {
      if (group.id == groupId) {
        return group.name;
      }
    }
    return null;
  }

  int buildingCountForGroup(String groupId) {
    return _buildings.where((building) => building.groupId == groupId).length;
  }

  MaintenanceGroup addGroup(String name) {
    final group = MaintenanceGroup(id: _nextId(), name: name.trim());
    _groups.add(group);
    notifyListeners();
    return group;
  }

  void updateGroup(String groupId, String name) {
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return;

    _groups[index] = _groups[index].copyWith(name: name.trim());
    notifyListeners();
  }

  bool deleteGroup(String groupId) {
    final hasBuildings = _buildings.any((building) => building.groupId == groupId);
    if (hasBuildings) {
      return false;
    }

    _groups.removeWhere((group) => group.id == groupId);
    if (selectedGroupId == groupId) {
      selectedGroupId = null;
    }
    notifyListeners();
    return true;
  }

  Building addBuilding(Building building) {
    final newBuilding = Building(
      id: _nextId(),
      name: building.name,
      address: building.address,
      city: building.city,
      district: building.district,
      groupId: building.groupId,
      neighborhood: building.neighborhood,
      latitude: building.latitude,
      longitude: building.longitude,
      contactPhone: building.contactPhone,
      notes: building.notes,
    );

    _buildings.add(newBuilding);
    notifyListeners();
    return newBuilding;
  }

  void updateBuilding(String id, Building building) {
    final index = _buildings.indexWhere((item) => item.id == id);
    if (index == -1) return;

    _buildings[index] = Building(
      id: id,
      name: building.name,
      address: building.address,
      city: building.city,
      district: building.district,
      groupId: building.groupId,
      neighborhood: building.neighborhood,
      latitude: building.latitude,
      longitude: building.longitude,
      contactPhone: building.contactPhone,
      notes: building.notes,
    );
    notifyListeners();
  }

  void deleteBuilding(String buildingId) {
    _buildings.removeWhere((building) => building.id == buildingId);
    notifyListeners();
  }

  void setSelectedGroup(String? groupId) {
    selectedGroupId = groupId;
    notifyListeners();
  }

  String _nextId() {
    _idCounter += 1;
    return _idCounter.toString();
  }

  String mapsUrlForBuilding(Building building) {
    final hasCoordinates = building.latitude != null && building.longitude != null;
    final query = hasCoordinates
        ? '${building.latitude},${building.longitude}'
        : building.fullAddress;

    return 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}';
  }
}
