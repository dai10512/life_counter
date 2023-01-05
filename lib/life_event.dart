import 'package:objectbox/objectbox.dart';

@Entity()
class LifeEvent {
  LifeEvent({
    required this.title,
    required this.count,
  });
  @Id()
  int id = 0;
  final String title;
  int count;
}
