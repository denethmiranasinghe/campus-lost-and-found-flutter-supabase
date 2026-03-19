/// Item Model for Lost and Found Items
class ItemModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String category;
  final String status; // 'lost' or 'found'
  final String location;
  final DateTime date;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional fields for display
  String? userName;
  String? userEmail;

  ItemModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.location,
    required this.date,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
    this.userEmail,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      status: json['status'] as String,
      location: json['location'] as String,
      date: DateTime.parse(json['date'] as String),
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      userName: json['user_name'] as String?,
      userEmail: json['user_email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'location': location,
      'date': date.toIso8601String(),
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ItemModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? category,
    String? status,
    String? location,
    DateTime? date,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userName,
    String? userEmail,
  }) {
    return ItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      location: location ?? this.location,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}
