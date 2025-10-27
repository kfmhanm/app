abstract class AdValidationStates {}

class AdValidationInitial extends AdValidationStates {}

class AdValidationLoading extends AdValidationStates {}

class AdValidationSuccess extends AdValidationStates {}

class AdValidationFailed extends AdValidationStates {
  final String errorMessage;
  AdValidationFailed(this.errorMessage);
}

