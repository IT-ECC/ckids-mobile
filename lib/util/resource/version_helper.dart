bool checkAppVersion(String appVersion, String enforceVersion) {
  bool isShowVersionScreen = false;
  if (enforceVersion.isNotEmpty) {
    List<String> app = enforceVersion.split("-");
    List<String> app1 = appVersion.split("-");
    List<String> version = app[0].split(".");
    List<String> version1 = app1[0].split(".");
    for (num i = 0; i < version1.length; i++) {
      num oldversion = num.tryParse(version1[i.toInt()].toString()) ?? 0;
      if (oldversion != 0) {
        num newversion = num.tryParse(version[i.toInt()]) ?? 0;
        if (newversion != 0) {
          if (oldversion < newversion) {
            isShowVersionScreen = true;
            break;
          }
        } else {
          if (version1[i.toInt()] != version[i.toInt()]) {
            isShowVersionScreen = true;
            break;
          }
        }
      } else {
        if (version1[i.toInt()] != version[i.toInt()]) {
          isShowVersionScreen = true;
          break;
        }
      }
      if (isShowVersionScreen) {
        break;
      }
    }
  }

  return isShowVersionScreen;
}
