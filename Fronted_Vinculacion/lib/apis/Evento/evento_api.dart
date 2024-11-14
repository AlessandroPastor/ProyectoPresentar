
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vinculacion/modelo/EventoModelo.dart';
import 'package:vinculacion/modelo/Inscripciones.dart';
import 'package:vinculacion/util/UrlApi.dart';

part 'evento_api.g.dart';

@RestApi(baseUrl: UrlApi.urlApix)
abstract class EventoApi {
  factory EventoApi(Dio dio, {String baseUrl}) = _EventoApi;
  static EventoApi create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return EventoApi(dio);
  }

  @GET("/evento")
  Future<List<EventoModelo>> list(@Header("Authorization") String token);

  @POST("/evento")
  Future<EventoModelo> saveEvento(@Header("Authorization") String token, @Body() EventoModelo evento);

  @PUT("/evento")
  Future<EventoModelo> updateEvento(
  @Header("Authorization") String token, @Path("id") int id,@Body() EventoModelo evento);

  @GET("/evento/{id}")
  Future<EventoModelo> getEventoById(@Header("Authorization") String token, @Path("id") int id);

  @DELETE("/evento/{id}")
  Future<List<EventoModelo>> deleteEvento(@Header("Authorization") String token, @Path("id") int id);

  // Método para finalizar un evento
  @PUT("/evento/{id}/finalizar")
  Future<String> finalizarEvento(
      @Header("Authorization") String token,
      @Path("id") int id
      );

  @GET("/evento/{id}/inscripciones")
  Future<EventoDto> getEventoConInscripciones(
      @Header("Authorization") String token,
      @Path("id") int id,
      );

}
