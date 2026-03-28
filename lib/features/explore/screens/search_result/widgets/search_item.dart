import 'package:carboneto/common/widgets/result/result_widget.dart';
import 'package:carboneto/features/explore/controllers/search_controller.dart';
import 'package:carboneto/features/explore/screens/search_result/widgets/exercise_result_widget.dart';
import 'package:carboneto/features/explore/screens/search_result/widgets/user_result_widget.dart';
import 'package:carboneto/features/personalization/models/user_search_model.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

/// Sealed-style item wrapper for heterogeneous search results.
/// Each subtype knows how to build itself — no switch statements outside.
abstract class SearchItem {
  const SearchItem();

  factory SearchItem.user(UserSearchModel u)       => _UserItem(u);
  factory SearchItem.training(TrainingModel t)     => _TrainingItem(t);
  factory SearchItem.exercise(ExerciseModel e)     => _ExerciseItem(e);
  factory SearchItem.sectionHeader(String label)   => _SectionHeaderItem(label);

  Widget build(BuildContext context, CbSearchController controller);
}


class _UserItem extends SearchItem {
  const _UserItem(this.user);
  final UserSearchModel user;

  @override
  Widget build(BuildContext context, CbSearchController controller) =>
      UserResultWidget(user: user);
}


class _TrainingItem extends SearchItem {
  const _TrainingItem(this.training);
  final TrainingModel training;

  @override
  Widget build(BuildContext context, CbSearchController controller) =>
      ResultWidget(training: training);
}


class _ExerciseItem extends SearchItem {
  const _ExerciseItem(this.exercise);
  final ExerciseModel exercise;

  @override
  Widget build(BuildContext context, CbSearchController controller) =>
      ExerciseSearchCard(exercise: exercise);
}


class _SectionHeaderItem extends SearchItem {
  const _SectionHeaderItem(this.label);
  final String label;

  @override
  Widget build(BuildContext context, CbSearchController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: CbColors.primary),
      ),
    );
  }
}
