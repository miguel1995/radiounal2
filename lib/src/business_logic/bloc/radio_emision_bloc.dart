import 'package:radiounal2/src/data/models/emision_model.dart';
import 'package:radiounal2/src/data/repositories/radio_repository.dart';
import 'package:rxdart/rxdart.dart';

class RadioEmisionBloc{

  final _repository = RadioRepository();
  final _subject = BehaviorSubject<List<EmisionModel>>();

  fetchEmision(int uid) async {
    List<EmisionModel> list = await _repository.findEmision(uid);
    _subject.sink.add(list);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<List<EmisionModel>> get subject => _subject;
}