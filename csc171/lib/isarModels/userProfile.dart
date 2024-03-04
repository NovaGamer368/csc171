import 'package:isar/isar.dart';

part 'userProfile.g.dart';

@Collection()
class UserProfile {
  Id id = Isar.autoIncrement;

  String imagePath = '';

  UserProfile();
}
