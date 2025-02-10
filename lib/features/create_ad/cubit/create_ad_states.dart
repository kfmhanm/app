abstract class CreateAdStates {}

class CreateAdInitial extends CreateAdStates {}

class CreateAdSuccess extends CreateAdStates {}

class CreateAdFailed extends CreateAdStates {}

class Update extends CreateAdStates {}

class LoadFeatures extends CreateAdStates {}

class LoadFeaturesSuccess extends CreateAdStates {}

class LoadFeaturesFailed extends CreateAdStates {}

class LoadFeaturesCategory extends CreateAdStates {}

class LoadFeaturesSuccessCategory extends CreateAdStates {}

class LoadFeaturesFailedCategory extends CreateAdStates {}
