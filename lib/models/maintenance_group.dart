class MaintenanceGroup {
  MaintenanceGroup({required this.id, required this.name});

  final String id;
  final String name;

  MaintenanceGroup copyWith({String? name}) {
    return MaintenanceGroup(id: id, name: name ?? this.name);
  }
}
