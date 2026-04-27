import 'package:flutter/material.dart';
import 'package:swaplio_frontend/core/paginated_response.dart';
import 'package:swaplio_frontend/features/listings/services/listing_service.dart';

import '../../listings/models/listing_model.dart';
import '../../listings/widgets/listing_card.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  late Future<PaginatedResponse<ListingModel>> _listingFuture;

  @override
  void initState() {
    super.initState();
    _listingFuture = ListingService().getListings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: FutureBuilder(
          future: _listingFuture,
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }

            if(snapshot.hasError){
              return Center(child: Text("Error: ${snapshot.error}",style: TextStyle(color: Colors.red),));
            }

            final listings = snapshot.data!.content;
            
            return ListView.builder(
                itemCount:listings.length,
                itemBuilder:(context,index){
                  final listing = listings[index];
                  return ListingCard(listing: listing);
                },
            );
          }
      ),
    );
  }

}