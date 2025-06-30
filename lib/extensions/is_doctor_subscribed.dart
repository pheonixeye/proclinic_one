import 'package:proklinik_one/providers/px_doc_subscription_info.dart';

extension IsDoctorSubscribed on PxDocSubscriptionInfo {
  bool get isDoctorSubscribed => hasAciveSubscriptions;
}
