part of 'get_place_details_cubit.dart';

@immutable
sealed class GetPlaceDetailsState {}

final class GetPlaceDetailsInitial extends GetPlaceDetailsState {}

final class GetPlaceDetailsLoading extends GetPlaceDetailsState {}

final class GetPlaceDetailsFailure extends GetPlaceDetailsState {
  final String errMessage;

  GetPlaceDetailsFailure({required this.errMessage});
}

final class GetPlaceDetailsSuccess extends GetPlaceDetailsState {
  final PlaceDetailsModel placeDetails;

  GetPlaceDetailsSuccess({required this.placeDetails});
}
