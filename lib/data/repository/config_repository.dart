import 'package:eccmobile/data/models/response/config_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigRepository {
  Stream<VersionResponse> getConfig() {
    try {
      return FirebaseFirestore.instance
          .collection('config')
          .snapshots().map((QuerySnapshot event) {
            Map<String, dynamic> map = event.docs.firstWhere((DocumentSnapshot documentSnapshot) {
              return documentSnapshot.id == 'version';
            }).data() as Map<String, dynamic>;
            return VersionResponse.fromJson(map);
      });
    } on Exception catch (e, s) {
      print(e.toString());

      return Stream.empty();
    }
  }
}