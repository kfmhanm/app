class AdValidationResponse {
  final Header? header;
  final Body? body;

  AdValidationResponse({this.header, this.body});

  factory AdValidationResponse.fromJson(Map<String, dynamic> json) {
    return AdValidationResponse(
      header: json['Header'] != null ? Header.fromJson(json['Header']) : null,
      body: json['Body'] != null ? Body.fromJson(json['Body']) : null,
    );
  }
}

class Header {
  final String? resTime;
  final String? chId;
  final String? refId;
  final String? reqID;
  final Status? status;

  Header({
    this.resTime,
    this.chId,
    this.refId,
    this.reqID,
    this.status,
  });

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      resTime: json['ResTime'],
      chId: json['ChId'],
      refId: json['RefId'],
      reqID: json['ReqID'],
      status: json['Status'] != null ? Status.fromJson(json['Status']) : null,
    );
  }
}

class Status {
  final int? code;
  final String? description;

  Status({this.code, this.description});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      code: json['Code'],
      description: json['Description'],
    );
  }
}

class Body {
  final Result? result;
  final bool? success;
  final ApiError? error;

  Body({this.result, this.success, this.error});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      result: json['result'] != null ? Result.fromJson(json['result']) : null,
      success: json['success'],
      error: json['error'] != null ? ApiError.fromJson(json['error']) : null,
    );
  }
}

class Result {
  final bool? isValid;
  final Advertisement? advertisement;
  final String? message;

  Result({this.isValid, this.advertisement, this.message});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      isValid: json['isValid'],
      advertisement: json['advertisement'] != null
          ? Advertisement.fromJson(json['advertisement'])
          : null,
      message: json['message'],
    );
  }
}

class Advertisement {
  final String? advertiserId;
  final String? adLicenseNumber;
  final String? deedNumber;
  final String? advertiserName;
  final String? phoneNumber;
  final String? brokerageAndMarketingLicenseNumber;
  final bool? isConstrained;
  final bool? isPawned;
  final bool? isHalted;
  final bool? isTestment;
  final int? streetWidth;
  final int? propertyArea;
  final int? propertyPrice;
  final int? landTotalPrice;
  final String? propertyType;
  final String? advertisementType;
  final Location? location;
  final String? propertyFace;
  final String? planNumber;
  final String? landNumber;
  final String? obligationsOnTheProperty;
  final String? guaranteesAndTheirDuration;
  final List<String>? channels;
  final String? mainLandUseTypeName;
  final String? redZoneTypeName;
  final List<String>? propertyUtilities;
  final String? creationDate;
  final String? endDate;
  final String? adLicenseUrl;
  final String? adSource;
  final String? titleDeedTypeName;
  final String? locationDescriptionOnMOJDeed;
  final String? notes;
  final Borders? borders;

  Advertisement({
    this.advertiserId,
    this.adLicenseNumber,
    this.deedNumber,
    this.advertiserName,
    this.phoneNumber,
    this.brokerageAndMarketingLicenseNumber,
    this.isConstrained,
    this.isPawned,
    this.isHalted,
    this.isTestment,
    this.streetWidth,
    this.propertyArea,
    this.propertyPrice,
    this.landTotalPrice,
    this.propertyType,
    this.advertisementType,
    this.location,
    this.propertyFace,
    this.planNumber,
    this.landNumber,
    this.obligationsOnTheProperty,
    this.guaranteesAndTheirDuration,
    this.channels,
    this.mainLandUseTypeName,
    this.redZoneTypeName,
    this.propertyUtilities,
    this.creationDate,
    this.endDate,
    this.adLicenseUrl,
    this.adSource,
    this.titleDeedTypeName,
    this.locationDescriptionOnMOJDeed,
    this.notes,
    this.borders,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      advertiserId: json['advertiserId'],
      adLicenseNumber: json['adLicenseNumber'],
      deedNumber: json['deedNumber'],
      advertiserName: json['advertiserName'],
      phoneNumber: json['phoneNumber'],
      brokerageAndMarketingLicenseNumber:
          json['brokerageAndMarketingLicenseNumber'],
      isConstrained: json['isConstrained'],
      isPawned: json['isPawned'],
      isHalted: json['isHalted'],
      isTestment: json['isTestment'],
      streetWidth: json['streetWidth'],
      propertyArea: json['propertyArea'],
      propertyPrice: json['propertyPrice'],
      landTotalPrice: json['landTotalPrice'],
      propertyType: json['propertyType'],
      advertisementType: json['advertisementType'],
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      propertyFace: json['propertyFace'],
      planNumber: json['planNumber'],
      landNumber: json['landNumber'],
      obligationsOnTheProperty: json['obligationsOnTheProperty'],
      guaranteesAndTheirDuration: json['guaranteesAndTheirDuration'],
      channels: json['channels'] != null
          ? List<String>.from(json['channels'])
          : null,
      mainLandUseTypeName: json['mainLandUseTypeName'],
      redZoneTypeName: json['redZoneTypeName'],
      propertyUtilities: json['propertyUtilities'] != null
          ? List<String>.from(json['propertyUtilities'])
          : null,
      creationDate: json['creationDate'],
      endDate: json['endDate'],
      adLicenseUrl: json['adLicenseUrl'],
      adSource: json['adSource'],
      titleDeedTypeName: json['titleDeedTypeName'],
      locationDescriptionOnMOJDeed: json['locationDescriptionOnMOJDeed'],
      notes: json['notes'],
      borders:
          json['borders'] != null ? Borders.fromJson(json['borders']) : null,
    );
  }
}

class Location {
  final String? region;
  final String? regionCode;
  final String? city;
  final String? cityCode;
  final String? district;
  final String? districtCode;
  final String? street;
  final String? postalCode;
  final String? buildingNumber;
  final String? additionalNumber;
  final String? longitude;
  final String? latitude;

  Location({
    this.region,
    this.regionCode,
    this.city,
    this.cityCode,
    this.district,
    this.districtCode,
    this.street,
    this.postalCode,
    this.buildingNumber,
    this.additionalNumber,
    this.longitude,
    this.latitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      region: json['region'],
      regionCode: json['regionCode'],
      city: json['city'],
      cityCode: json['cityCode'],
      district: json['district'],
      districtCode: json['districtCode'],
      street: json['street'],
      postalCode: json['postalCode'],
      buildingNumber: json['buildingNumber'],
      additionalNumber: json['additionalNumber'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}

class Borders {
  final String? northLimitName;
  final String? northLimitDescription;
  final String? northLimitLengthChar;
  final String? eastLimitName;
  final String? eastLimitDescription;
  final String? eastLimitLengthChar;
  final String? westLimitName;
  final String? westLimitDescription;
  final String? westLimitLengthChar;
  final String? southLimitName;
  final String? southLimitDescription;
  final String? southLimitLengthChar;

  Borders({
    this.northLimitName,
    this.northLimitDescription,
    this.northLimitLengthChar,
    this.eastLimitName,
    this.eastLimitDescription,
    this.eastLimitLengthChar,
    this.westLimitName,
    this.westLimitDescription,
    this.westLimitLengthChar,
    this.southLimitName,
    this.southLimitDescription,
    this.southLimitLengthChar,
  });

  factory Borders.fromJson(Map<String, dynamic> json) {
    return Borders(
      northLimitName: json['northLimitName'],
      northLimitDescription: json['northLimitDescription'],
      northLimitLengthChar: json['northLimitLengthChar'],
      eastLimitName: json['eastLimitName'],
      eastLimitDescription: json['eastLimitDescription'],
      eastLimitLengthChar: json['eastLimitLengthChar'],
      westLimitName: json['westLimitName'],
      westLimitDescription: json['westLimitDescription'],
      westLimitLengthChar: json['westLimitLengthChar'],
      southLimitName: json['southLimitName'],
      southLimitDescription: json['southLimitDescription'],
      southLimitLengthChar: json['southLimitLengthChar'],
    );
  }
}

class ApiError {
  final int? code;
  final String? message;
  final String? details;

  ApiError({this.code, this.message, this.details});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'],
      message: json['message'],
      details: json['details'],
    );
  }
}

