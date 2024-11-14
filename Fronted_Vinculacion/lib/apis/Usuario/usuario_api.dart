import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vinculacion/modelo/CarreraModelo.dart';
import 'package:vinculacion/modelo/UsuarioModelo.dart';
import 'package:vinculacion/util/UrlApi.dart';

part 'usuario_api.g.dart';

@RestApi(baseUrl: UrlApi.urlApix)
abstract class UsuarioApi{
  factory UsuarioApi(Dio dio,{String baseUrl})=_UsuarioApi;
  
  static UsuarioApi create(){
    final dio= Dio();
    dio.interceptors.add(PrettyDioLogger());
    return UsuarioApi(dio);
  }

  @POST("/auth/register")
  Future<UsuarioDto> register(@Body() UsuarioCrearDto usuario);

  @POST("/auth/login")
  Future<RespUsuarioModelo> login(@Body() UsuarioModelo usuario);

  @GET("/auth/codigo/{codigo}")
  Future<UsuarioModelo> buscarPorCodigo(
      @Header("Authorization") String token,
      @Path("codigo") String codigo,
      );

  @GET("/auth/dni/{dni}")
  Future<UsuarioModelo> buscarPorDni(
      @Header("Authorization") String token,
      @Path("dni") String dni,
      );

}