enum PostApiStatus {
  initial,
  loading,
  success,
  error,
  locationServiceDisabled,
  permissionDenied,
  permissionDeniedForever,
  loadingMore,
}



enum ValidationType {
  none,
  required,
  email,
  phone,
  minLength,
  custom,
  maxLength
}

