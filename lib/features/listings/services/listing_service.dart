import 'dart:convert';

import 'package:swaplio_frontend/core/constants.dart';
import 'package:swaplio_frontend/core/paginated_response.dart';
import 'package:swaplio_frontend/features/listings/models/listing_model.dart';
import 'package:http/http.dart' as http;

class ListingService {
  Future<PaginatedResponse<ListingModel>> getListings({int page = 0,int size = 10 }) async {
      final response = await http.get(
          Uri.parse(Constants.baseUrl + "/listings").replace(
            queryParameters: {
              "page" : page.toString(),
              "size" : size.toString(),
            }
          )
      );
      if(response.statusCode == 200){
        return PaginatedResponse.fromJson(jsonDecode(response.body), ListingModel.fromJson);
      }else{
        throw Exception("Failed to load listings");
      }
  }
}