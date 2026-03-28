import 'package:flutter/material.dart';

import '../../../data/models/member_model.dart';
import '../../../data/models/sport_model.dart';
import '../../../data/repositories/member_repository.dart';
import '../../../data/repositories/sport_repository.dart';

class MembersController extends ChangeNotifier {
  final MemberRepository _memberRepository = MemberRepository();
  final SportRepository _sportRepository = SportRepository();

  List<MemberWithSports> members = [];
  List<SportModel> sports = [];
  bool isLoading = false;

  Future<void> loadInitialData() async {
    isLoading = true;
    notifyListeners();

    sports = await _sportRepository.getAllSports();
    members = await _memberRepository.getAllMembersWithSports();

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMembers() async {
    isLoading = true;
    notifyListeners();

    members = await _memberRepository.getAllMembersWithSports();

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadSports() async {
    sports = await _sportRepository.getAllSports();
    notifyListeners();
  }

  Future<void> addMember(
    MemberModel member,
    List<int> sportIds,
  ) async {
    isLoading = true;
    notifyListeners();

    await _memberRepository.addMemberWithSports(member, sportIds);
    members = await _memberRepository.getAllMembersWithSports();

    isLoading = false;
    notifyListeners();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      await loadMembers();
      return;
    }

    isLoading = true;
    notifyListeners();

    members = await _memberRepository.searchMembersWithSports(query);

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteMember(int id) async {
    isLoading = true;
    notifyListeners();

    await _memberRepository.deleteMember(id);
    members = await _memberRepository.getAllMembersWithSports();

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateMemberPhoto(int memberId, String photoPath) async {
    isLoading = true;
    notifyListeners();

    await _memberRepository.updateMemberPhoto(memberId, photoPath);
    members = await _memberRepository.getAllMembersWithSports();

    isLoading = false;
    notifyListeners();
  }

  Future<List<int>> getSelectedSportIds(int memberId) async {
      return await _memberRepository.getSportIdsByMemberId(memberId);
    }

    Future<void> updateMember(
      MemberModel member,
      List<int> sportIds,
    ) async {
      isLoading = true;
      notifyListeners();

      await _memberRepository.updateMemberWithSports(member, sportIds);
      members = await _memberRepository.getAllMembersWithSports();

      isLoading = false;
      notifyListeners();
    }
}