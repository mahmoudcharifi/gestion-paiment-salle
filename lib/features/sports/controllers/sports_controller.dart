import 'package:flutter/material.dart';

import '../../../data/models/sport_model.dart';
import '../../../data/repositories/sport_repository.dart';

class SportsController extends ChangeNotifier {
  final SportRepository _sportRepository = SportRepository();

  List<SportModel> sports = [];
  bool isLoading = false;

  Future<void> loadSports() async {
    isLoading = true;
    notifyListeners();

    sports = await _sportRepository.getAllSports();

    isLoading = false;
    notifyListeners();
  }

  Future<String?> addSport(String name) async {
    final trimmed = name.trim();

    if (trimmed.isEmpty) {
      return 'Le nom du sport est obligatoire';
    }

    final alreadyExists = sports.any(
      (sport) => sport.name.toLowerCase() == trimmed.toLowerCase(),
    );

    if (alreadyExists) {
      return 'Ce sport existe déjà';
    }

    isLoading = true;
    notifyListeners();

    try {
      await _sportRepository.addSport(trimmed);
      sports = await _sportRepository.getAllSports();
      return null;
    } catch (e) {
      return 'Erreur lors de l’ajout du sport';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> updateSport(int id, String name) async {
    final trimmed = name.trim();

    if (trimmed.isEmpty) {
      return 'Le nom du sport est obligatoire';
    }

    final alreadyExists = sports.any(
      (sport) =>
          sport.id != id &&
          sport.name.toLowerCase() == trimmed.toLowerCase(),
    );

    if (alreadyExists) {
      return 'Ce sport existe déjà';
    }

    isLoading = true;
    notifyListeners();

    try {
      await _sportRepository.updateSport(id, trimmed);
      sports = await _sportRepository.getAllSports();
      return null;
    } catch (e) {
      return 'Erreur lors de la modification';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSport(int id) async {
    isLoading = true;
    notifyListeners();

    await _sportRepository.deleteSport(id);
    sports = await _sportRepository.getAllSports();

    isLoading = false;
    notifyListeners();
  }
}