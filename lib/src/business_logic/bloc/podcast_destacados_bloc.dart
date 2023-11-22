

import 'package:radiounal2/src/data/models/episodio_model.dart';
import 'package:radiounal2/src/data/repositories/podcast_repository.dart';
import 'package:rxdart/rxdart.dart';

class PodcastDestacadosBloc{

  final _repository = PodcastRepository();
  final _subject = BehaviorSubject<List<EpisodioModel>>();

  fetchDestacados() async {
    List<EpisodioModel> modelList = await _repository.findDestacados();
    _subject.sink.add(modelList);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<List<EpisodioModel>> get subject => _subject;
}