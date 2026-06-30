class Building {
  Building({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.district,
    required this.groupId,
    this.neighborhood,
    this.latitude,
    this.longitude,
    this.contactPhone,
    this.notes,
  });

  final String id;
  final String name;
  final String address;
  final String city;
  final String district;
  final String groupId;
  final String? neighborhood;
  final double? latitude;
  final double? longitude;
  final String? contactPhone;
  final String? notes;

  String get fullAddress {
    final parts = <String>[address, district, city];
    final neighborhoodText = neighborhood?.trim();
    if (neighborhoodText != null && neighborhoodText.isNotEmpty) {
      parts.insert(1, neighborhoodText);
    }
    return parts.where((part) => part.trim().isNotEmpty).join(', ');
  }

  Building copyWith({
    String? name,
    String? address,
    String? city,
    String? district,
    String? groupId,
    Object? neighborhood = _noValue,
    Object? latitude = _noValue,
    Object? longitude = _noValue,
    Object? contactPhone = _noValue,
    Object? notes = _noValue,
  }) {
    return Building(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      district: district ?? this.district,
      groupId: groupId ?? this.groupId,
      neighborhood: identical(neighborhood, _noValue)
          ? this.neighborhood
          : neighborhood as String?,
      latitude: identical(latitude, _noValue)
          ? this.latitude
          : latitude as double?,
      longitude: identical(longitude, _noValue)
          ? this.longitude
          : longitude as double?,
      contactPhone: identical(contactPhone, _noValue)
          ? this.contactPhone
          : contactPhone as String?,
      notes: identical(notes, _noValue) ? this.notes : notes as String?,
    );
  }
}

const Object _noValue = Object();
