import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vinculacion/modelo/InscripcionesModelo.dart';
import 'package:vinculacion/util/UrlApi.dart';

part 'inscripciones_api.g.dart';

@RestApi(baseUrl: UrlApi.urlApix)
abstract class InscripcionesApi {
  factory InscripcionesApi(Dio dio, {String baseUrl}) = _InscripcionesApi;

  static InscripcionesApi create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return InscripcionesApi(dio);
  }
  @GET("/inscripciones")
  Future<List<InscripcionModelo>> listarInscripciones(@Header("Authorization") String token);

  @POST("/inscripciones/inscribirse")
  Future<InscripcionModelo> crearInscripcion(
      @Header("Authorization") String token,
      @Query("usuarioId") int usuarioId,
      @Query("eventoId") int eventoId,
      );


  @PUT("/inscripciones")
  Future<InscripcionModelo> actualizarInscripcion(
      @Header("Authorization") String token,
      @Body() InscripcionModelo inscripcion,
      );

  @PUT("/inscripciones/{id}/editarHoras")
  Future<String> editarHoras(
      @Header("Authorization") String token,
      @Path("id") int id,
      @Query("horasEditadas") int horasEditadas,
      );


  @GET("/inscripciones/{id}")
  Future<InscripcionModelo> obtenerInscripcionPorId(
      @Header("Authorization") String token,
      @Path("id") int id,
      );

  @DELETE("/inscripciones/{id}")
  Future<void> eliminarInscripcion(
      @Header("Authorization") String token,
      @Path("id") int id,
      );

  @GET("/inscripciones/isRegistered")
  Future<bool> checkUserRegistration(
      @Header("Authorization") String token,
      @Query("usuarioId") int usuarioId,
      @Query("eventoId") int eventoId,
      );



}
