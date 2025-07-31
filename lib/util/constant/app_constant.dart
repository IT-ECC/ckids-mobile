class AppConstant {
  // API URI
  static const String BASE_URL = 'https://ckids.eccchurch.app/api/v1/';

  // SHAREDPREFERENCE KEY
  static const String TOKEN = 'token';
  static const String USERNAME = 'username';
  static const String EMAIL = 'email';
  static const String PHOTO_PROFILE = 'photo_profile';
  static const String IS_ONBOARDING = 'is_onboarding';
  static const String IS_ADMIN = 'is_admin';

  static List<String> dataFamilyRole = ["Ayah", "Ibu", "Anak ke 1", "Anak ke 2", "Anak ke 3", "Anak ke 4", "Anak ke 5"];

  // GENDER
  static const String LAKI_LAKI = 'Laki-Laki';
  static const String PEREMPUAN = 'Perempuan';

  static List<String> dataGender = [LAKI_LAKI, PEREMPUAN];

  // FAMILY ROLE
  static const String AYAH = 'Ayah';
  static const String IBU = 'Ibu';
  static const String ANAK = 'Anak';

  static List<String> dataAge = ['0','1','2','3','4','5','6','7','8','9','10','11'];
}