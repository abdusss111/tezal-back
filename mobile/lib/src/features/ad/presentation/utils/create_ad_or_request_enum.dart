//
enum CreateAdOrRequestEnum { ad, request, unknown }

CreateAdOrRequestEnum getCreateAdOrRequestEnumFromString(String value) {
  switch (value) {
    case 'ad':
      return CreateAdOrRequestEnum.ad;
    case 'request':
      return CreateAdOrRequestEnum.request;
    default:
      return CreateAdOrRequestEnum.unknown;
  }
}
//