import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swaplio_frontend/features/listings/models/listing_model.dart';

class ListingCard extends StatelessWidget{
  final ListingModel listing;
  const ListingCard({super.key,required this.listing});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.brown,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            listing.primaryImageUrl != null
                ? Image.network(listing.primaryImageUrl!)
                : const Icon(Icons.image_not_supported),
            SizedBox(height: 10,),
            Text(listing.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10,),
            Text("₹${listing.price.toStringAsFixed(0)}"),
            SizedBox(height: 10,),
            Text(listing.condition)
          ],
        ),
      ),
    );
  }

}