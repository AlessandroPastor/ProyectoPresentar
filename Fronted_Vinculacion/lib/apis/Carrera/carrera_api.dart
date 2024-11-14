import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vinculacion/modelo/CarreraModelo.dart';
import 'package:vinculacion/util/UrlApi.dart';

part 'carrera_api.g.dart';

@RestApi(baseUrl: UrlApi.urlApix)
abstract class CarreraApi {
  factory CarreraApi(Dio dio, {String baseUrl}) = _CarreraApi;

  static CarreraApi create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return CarreraApi(dio);
  }

  // Equivalent to @GetMapping() - List all carreras
  @GET("/carreras")
  Future<List<CarreraDto>> listCarreras(@Header("Authorization") String token);

  @POST("/carreras")
  Future<CarreraDto> saveCarrera(@Header("Authorization") String token, @Body() CarreraDto carrera);

  @PUT("/carreras")
  Future<CarreraDto> updateCarrera(@Header("Authorization") String token, @Body() CarreraDto carrera);

  @GET("/carreras/{id}")
  Future<CarreraDto> getCarreraById(@Header("Authorization") String token, @Path("id") int id);

  @DELETE("/carreras/{id}")
  Future<List<CarreraDto>> deleteCarrera(@Header("Authorization") String token, @Path("id") int id);
}
