class BrokersModel {
  final List<BrokerModel> brokers;

  BrokersModel({
    required this.brokers,
  });

  factory BrokersModel.fromJson(Map<String, dynamic> json) {
    return BrokersModel(
      brokers: List<BrokerModel>.from(
          json['data'].map((x) => BrokerModel.fromJson(x))),
    );
  }
}

class BrokerModel {
  final int? id;
  final String? name;
  final String? image;
  final Location? location;
  bool? has_chat;
  String? room_id;

  BrokerModel({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
    required this.has_chat,
    required this.room_id,
  });

  factory BrokerModel.fromJson(Map<String, dynamic> json) {
    return BrokerModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      room_id: json['room_id']?.toString(),
      has_chat: json['has_chat'],
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'location': location?.toJson(),
    };
  }
}

class Location {
  final String lat;
  final String lng;
  final String text;

  Location({
    required this.lat,
    required this.lng,
    required this.text,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'],
      lng: json['lng'],
      text: json['text'] == null ? '' : json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'text': text,
    };
  }
}
