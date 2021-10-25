import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/blocs/purchase/purchase_bloc.dart';

class AdvertCard extends StatelessWidget {
  const AdvertCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseBloc, PurchaseState>(
      builder: (context, state) {
        if (state is PurchaseGetOfferingsSuccess &&
            state.isSubscriptionActive) {
          return Container();
        } else {
          return _buildAdvert();
        }
      },
    );
  }

  Widget _buildAdvert() {
    return Card(
      child: Container(
        color: Colors.amber,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text('This is advert'),
          ),
        ),
      ),
    );
  }
}
