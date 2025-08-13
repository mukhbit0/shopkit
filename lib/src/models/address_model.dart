import 'package:equatable/equatable.dart';

/// Model representing a shipping or billing address
class AddressModel extends Equatable {
  const AddressModel({
    required this.id,
    required this.fullName,
    required this.street1,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.street2,
    this.phone,
    this.email,
    this.company,
    this.isDefault = false,
    this.type = 'home',
    this.instructions,
    this.latitude,
    this.longitude,
  });

  /// Create AddressModel from JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        street1: json['street1'] as String,
        street2: json['street2'] as String?,
        city: json['city'] as String,
        state: json['state'] as String,
        postalCode: json['postalCode'] as String,
        country: json['country'] as String,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        company: json['company'] as String?,
        isDefault: json['isDefault'] as bool? ?? false,
        type: json['type'] as String? ?? 'home',
        instructions: json['instructions'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
      );

  /// Unique address identifier
  final String id;

  /// Full name of the recipient
  final String fullName;

  /// Street address line 1
  final String street1;

  /// Street address line 2 (optional)
  final String? street2;

  /// City name
  final String city;

  /// State/province/region
  final String state;

  /// Postal/ZIP code
  final String postalCode;

  /// Country name or code
  final String country;

  /// Phone number (optional)
  final String? phone;

  /// Email address (optional)
  final String? email;

  /// Company name (optional)
  final String? company;

  /// Whether this is the default address
  final bool isDefault;

  /// Convenience getter for compatibility
  String get street => street1;

  /// Address type (e.g., 'home', 'work', 'other')
  final String type;

  /// Special delivery instructions
  final String? instructions;

  /// Latitude for mapping (optional)
  final double? latitude;

  /// Longitude for mapping (optional)
  final double? longitude;

  /// Get formatted address string for display
  String get formattedAddress {
    final parts = <String>[
      street1,
      if (street2?.isNotEmpty == true) street2!,
      '$city, $state $postalCode',
      country,
    ];
    return parts.join('\n');
  }

  /// Get single line address format
  String get singleLineAddress {
    final parts = <String>[
      street1,
      if (street2?.isNotEmpty == true) street2!,
      city,
      state,
      postalCode,
      country,
    ];
    return parts.join(', ');
  }

  /// Check if address has geolocation data
  bool get hasLocation => latitude != null && longitude != null;

  /// Validate required fields
  bool get isValid =>
      fullName.isNotEmpty &&
      street1.isNotEmpty &&
      city.isNotEmpty &&
      state.isNotEmpty &&
      postalCode.isNotEmpty &&
      country.isNotEmpty;

  /// Convert AddressModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'fullName': fullName,
        'street1': street1,
        'street2': street2,
        'city': city,
        'state': state,
        'postalCode': postalCode,
        'country': country,
        'phone': phone,
        'email': email,
        'company': company,
        'isDefault': isDefault,
        'type': type,
        'instructions': instructions,
        'latitude': latitude,
        'longitude': longitude,
      };

  /// Create a copy with modified properties
  AddressModel copyWith({
    String? id,
    String? fullName,
    String? street1,
    String? street2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? phone,
    String? email,
    String? company,
    bool? isDefault,
    String? type,
    String? instructions,
    double? latitude,
    double? longitude,
  }) =>
      AddressModel(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        street1: street1 ?? this.street1,
        street2: street2 ?? this.street2,
        city: city ?? this.city,
        state: state ?? this.state,
        postalCode: postalCode ?? this.postalCode,
        country: country ?? this.country,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        company: company ?? this.company,
        isDefault: isDefault ?? this.isDefault,
        type: type ?? this.type,
        instructions: instructions ?? this.instructions,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        fullName,
        street1,
        street2,
        city,
        state,
        postalCode,
        country,
        phone,
        email,
        company,
        isDefault,
        type,
        instructions,
        latitude,
        longitude,
      ];
}
