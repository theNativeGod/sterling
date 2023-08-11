import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sterling/models/payment_model.dart';
import 'package:sterling/view_models/payment_view.dart';

import '../../../global_utils/global_export.dart';

class PaymentHistoryTabView extends StatelessWidget {
  const PaymentHistoryTabView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var _payProvider = Provider.of<PaymentView>(context);
    List<Payment> payments = _payProvider.payments;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 18,
      ),
      child: payments.isEmpty
          ? Container(
              // height: 100,
              // width: 100,
              child: Image.asset('assets/images/nodata.png'),
            )
          : Column(
              children: [
                ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemCount: payments.length,
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) => PaymentHistoryCard(
                    transactionNo: payments[i].transactionNo,
                    amount: payments[i].amount,
                    paymentDate: payments[i].paymentDate,
                    paymentSource: payments[i].paymentSource,
                    status: payments[i].status,
                    tripId: payments[i].tripId,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                ThemeButton(
                  buttonText: 'Load More',
                  onTap: () async {
                    await Provider.of<PaymentView>(context, listen: false)
                        .loadMore(context);
                  },
                ),
              ],
            ),
    );
  }
}
