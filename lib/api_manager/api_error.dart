class ApiError {
  const ApiError({
    this.errorCode,
    this.message,
    this.extraData,
  });

  final String? errorCode;
  final String? message;
  final dynamic extraData;
}
