import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/functions/dprint.dart';
import 'package:proklinik_one/models/doctor_subscription.dart';

class DocSubPayApi {
  const DocSubPayApi();

  static const String doctor_subscription_collection = 'doctor_subscriptions';
  static const String subscription_payment_collection =
      'doctor_subscription_payment';

  static Future<void> updateSubscriptionPaymentsAndActivateDoctorSubscription({
    required String doc_id,
    required String x_pay_payment_id,
    required String x_pay_transaction_id,
    required String x_pay_transaction_status,
    required double amount,
  }) async {
    late final String _subPaymentId;
    late final String _docSubId;

    try {
      final _paymentQuery = await PocketbaseHelper.pb
          .collection(subscription_payment_collection)
          .getFirstListItem(
              "x_pay_payment_id = $x_pay_payment_id && doc_id = $doc_id");
      _subPaymentId = _paymentQuery.id;
    } catch (e) {
      //TODO:
      dprint(e);
      return;
    }
    try {
      final _docSubQuery = await PocketbaseHelper.pb
          .collection(subscription_payment_collection)
          .update(
        _subPaymentId,
        body: {
          'x_pay_transaction_id': x_pay_transaction_id,
          'x_pay_transaction_status': x_pay_transaction_status,
          'amount': amount,
        },
      );
      _docSubId = _docSubQuery.id;
    } catch (e) {
      //TODO:
      dprint(e);
      return;
    }

    try {
      await PocketbaseHelper.pb
          .collection(doctor_subscription_collection)
          .update(
        _docSubId,
        body: {'subscription_status': 'active'},
      );
    } catch (e) {
      //TODO:
      dprint(e);
      return;
    }
  }

  static Future<void> updateSubPayXpayPaymentReference({
    required String sub_pay_id,
    required String x_pay_payment_id,
  }) async {
    await PocketbaseHelper.pb
        .collection(subscription_payment_collection)
        .update(
      sub_pay_id,
      body: {
        'x_pay_payment_id': x_pay_payment_id,
      },
    );
  }

  static Future<void> createDoctorSubscriptionAndSubscriptionPaymentRefrences({
    required DoctorSubscription doctorSubscription,
    required double amount,
    required String x_pay_payment_id,
  }) async {
    late final String _docSubRefId;
    late final String _subPayRefId;
    try {
      final _docSubRequest = await PocketbaseHelper.pb
          .collection(doctor_subscription_collection)
          .create(
            body: doctorSubscription.toJson(),
          );
      _docSubRefId = _docSubRequest.id;
    } catch (e) {
      //TODO: handle
      dprint(e);
      return;
    }

    try {
      final _subPayRequest = await PocketbaseHelper.pb
          .collection(subscription_payment_collection)
          .create(
        body: {
          'doc_id': doctorSubscription.doc_id,
          'doctor_subscription_id': _docSubRefId,
          'amount': amount,
        },
      );
      _subPayRefId = _subPayRequest.id;
    } catch (e) {
      //TODO: handle
      dprint(e);
      return;
    }

    try {
      await PocketbaseHelper.pb
          .collection(doctor_subscription_collection)
          .update(
        _docSubRefId,
        body: {
          'payment_id': _subPayRefId,
        },
      );
    } catch (e) {
      //TODO: handle
      dprint(e);
      return;
    }

    try {
      await PocketbaseHelper.pb
          .collection(subscription_payment_collection)
          .update(
        _subPayRefId,
        body: {
          'x_pay_payment_id': x_pay_payment_id,
        },
      );
    } catch (e) {
      //TODO: handle
      dprint(e);
      return;
    }
  }
}
