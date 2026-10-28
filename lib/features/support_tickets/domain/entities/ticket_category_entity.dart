import 'package:equatable/equatable.dart';

class TicketCategoryEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String icon;
  final int slaHours;

  const TicketCategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.icon,
    required this.slaHours,
  });

  @override
  List<Object?> get props => [id, name, slug, description, icon, slaHours];
}
