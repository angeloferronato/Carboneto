import 'package:carboneto/data/repositories/follow/follow_repository.dart';
import 'package:carboneto/features/personalization/controllers/profile_base_controller.dart/profile_base_controller.dart';
import 'package:carboneto/features/personalization/models/user_search_model.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowSearchController extends GetxController with GetSingleTickerProviderStateMixin {
  static FollowSearchController get instance => Get.find();

  final FollowMode initialFollowMode;
  final String userId;
  FollowSearchController({this.initialFollowMode = FollowMode.followers, required this.userId});

  // Pre-loaded controllers
  final FollowRepository followRepository = Get.put(FollowRepository());
  late final ProfileBaseController profileBaseController;

  // Tab correlates
  final Rx<int> tabIndex = 0.obs;
  final Rx<FollowMode> followMode = FollowMode.followers.obs;
  late TabController tabController;

  // Query variables
  final TextEditingController searchQueryFollowersController = TextEditingController();
  final TextEditingController searchQueryFollowingController = TextEditingController();
  final Rx<String> searchQueryFollowers = ''.obs;
  final Rx<String> searchQueryFollowing = ''.obs;

  // Users lists
  final RxList<UserSearchModel> followersCache = <UserSearchModel>[].obs;
  final RxList<UserSearchModel> followersResults = <UserSearchModel>[].obs;
  final RxList<UserSearchModel> followingCache = <UserSearchModel>[].obs;
  final RxList<UserSearchModel> followingResults = <UserSearchModel>[].obs;

  // Loading
  final Rx<bool> isLoading = false.obs;

  // Offsets to skip the follow list appropriately
  final Rx<int> followersOffSet = 0.obs;
  final Rx<int> followingOffSet = 0.obs;
  final int pageSize = 20;


  @override
  void onInit() {
    profileBaseController = Get.put(ProfileBaseController(userId: userId), tag: userId);
    followMode.value = initialFollowMode;
    tabIndex.value = followMode.value == FollowMode.followers ? 0 : 1;
    debounce(
      searchQueryFollowers, 
      (_) => _performSearch(),
      time: Duration(milliseconds: 350),
    );

    debounce(
      searchQueryFollowing, 
      (_) => _performSearch(),
      time: Duration(milliseconds: 350)
    );

    tabController = TabController(length: 2, vsync: this, initialIndex: tabIndex.value);
    tabController.addListener(_handleTabChanged);

    loadInitial();
    super.onInit();
  }

  void _handleTabChanged() {
    if (!tabController.indexIsChanging) {
      tabIndex.value = tabController.index;
      followMode.value = tabIndex.value == 0 ? FollowMode.followers : FollowMode.following;
    }
  }

  Future<void> loadInitial() async {
    if (followersCache.isEmpty) {
      await loadFollowersPage();
      followersResults.assignAll(followersCache);
    }

    if (followingCache.isEmpty) {
      await loadFollowingPage();
      followingResults.assignAll(followingCache);
    }

  }

  Future<void> loadFollowersPage() async {
    final ids = profileBaseController.followersId.skip(followersOffSet.value).take(pageSize).toList();
    if (ids.isEmpty) return;

    isLoading.value = true;
    final users = await followRepository.loadFollowInitial(orderedIds: ids);

    followersCache.addAll(users);
    followersResults.addAll(users);
    followersOffSet.value += ids.length;
    isLoading.value = false;
  }

  Future<void> loadFollowingPage() async {
    final ids = profileBaseController.followingId.skip(followingOffSet.value).take(pageSize).toList();

    if (ids.isEmpty) return;

    isLoading.value = true;
    final users = await followRepository.loadFollowInitial(orderedIds: ids);

    followingCache.addAll(users);
    followingResults.addAll(users);
    followingOffSet.value += ids.length;
    isLoading.value = false;
  }

  void onSearchChanged(String value) {
    if (followMode.value == FollowMode.followers) {
      searchQueryFollowers.value = searchQueryFollowersController.text;
    } else {
      searchQueryFollowing.value = searchQueryFollowingController.text;
    }
  }

  Future<void> _performSearch() async {
    final query = followMode.value == FollowMode.followers ? searchQueryFollowers.value.trim().toLowerCase() : searchQueryFollowing.value.trim().toLowerCase();

    if (query.length < 2) {
      if (followMode.value == FollowMode.followers) {
        followersResults.assignAll(followersCache);
      } else {
        followingResults.assignAll(followingCache);
      }
      return;
    }

    isLoading.value = true;

    final ids = followMode.value == FollowMode.followers ? profileBaseController.followersId : profileBaseController.followingId;

    final users = await followRepository.searchUsersInIds(ids: ids, query: query);

    if (followMode.value == FollowMode.followers) {
      followersResults.assignAll(users);
    } else {
      followingResults.assignAll(users);
    }
    
    isLoading.value = false;
  }

  bool get showMoreButton {
    if (followMode.value == FollowMode.followers) {
      if (searchQueryFollowers.value.isNotEmpty) {
        return false;
      }
      if (followersResults.length < profileBaseController.followersId.length) {
        return true;
      } else {
        return false;
      }
    } else {
      if (searchQueryFollowing.value.isNotEmpty) {
        return false;
      }
      if (followingResults.length < profileBaseController.followingId.length) {
        return true;
      } else {
        return false;
      }
    }
  }
}