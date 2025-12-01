import 'workplace.dart';
import 'activity.dart';
import 'together.dart'; 

enum DiscoverSectionType {
  workplace,
  event,
  cowork,
  together,
}

class DiscoverSection {
  final DiscoverSectionType type;
  final List<dynamic> items;

  DiscoverSection({
    required this.type,
    required this.items,
  });

  List<Workplace> get workplaces =>
      items.whereType<Workplace>().toList();

  List<Activity> get activities =>
      items.whereType<Activity>().toList();

  List<Together> get togetherPeople =>
      items.whereType<Together>().toList();
}
