
import 'package:radiounal2/src/data/repositories/radio_repository.dart';
import 'package:rxdart/rxdart.dart';

class RadioProgramasBloc{

  final _repository = RadioRepository();
  final _subject = BehaviorSubject<Map<String, dynamic>>();

  fetchProgramas(int page) async {
    Map<String, dynamic> map = await _repository.findProgramas(page);
    _subject.sink.add(map);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<Map<String, dynamic>> get subject => _subject;
}