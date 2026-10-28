import '../../domain/entities/ticket_category_entity.dart';

class TicketCategoryModel {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String icon;
  final int slaHours;

  TicketCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.icon,
    required this.slaHours,
  });

  factory TicketCategoryModel.fromJson(Map<String, dynamic> json) {
    return TicketCategoryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      slaHours: json['sla_hours'] is int
          ? json['sla_hours']
          : int.tryParse(json['sla_hours']?.toString() ?? '24') ?? 24,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'icon': icon,
      'sla_hours': slaHours,
    };
  }

  TicketCategoryEntity toEntity() {
    return TicketCategoryEntity(
      id: id,
      name: name,
      slug: slug,
      description: description,
      icon: icon,
      slaHours: slaHours,
    );
  }
}
