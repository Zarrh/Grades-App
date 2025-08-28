import './subject.dart';

class GlobalSubject {

  GlobalSubject({required this.name, this.subjects = const {}});

  final String name;
  Map<String, Subject> subjects;
}