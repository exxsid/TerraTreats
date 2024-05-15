class ReviewModel {
  final int reviewId;
  final String userName;
  final dynamic rating;
  final String message;

  ReviewModel({
    required this.reviewId,
    required this.userName,
    required this.rating,
    required this.message,
  });

  factory ReviewModel.getReviews(Map<String, dynamic> json) {
    print("HAHAHAHAHAHAH ${json['rating'].runtimeType}");
    return ReviewModel(
      reviewId: json['review_id'] as int,
      userName: json['user_name'] as String,
      rating: json['rating'] as dynamic,
      message: json['message'] as String,
    );
  }
}
