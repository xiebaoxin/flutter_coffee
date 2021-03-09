import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'alioss.dart';
import '../../globleConfig.dart';

class AliOssAPI {
  //获取OSS Token
  static final String urlToken= "${GlobalConfig.aliossserver}/getAliyunOssToken";

  //获取OS上传图片服务器地址
  static final String urlUploadImageOss= GlobalConfig.aliossimgbase;

}

/*
 * 接口请求方法
 * 封装了传参方式及参数
 */
class AliOssApiService {

  /*
  * 获取OSS Token
  */
  static Future<dynamic> getOssToken(BuildContext context,
      {cancelToken}) async {
    Dio dio = Dio();
    dio.options.responseType = ResponseType.plain;
    return await dio.get(AliOssAPI.urlToken);
  }

  static Future<dynamic> uploadImage(BuildContext context, String uploadName,
      String filePath,{cancelToken,Function onSendProgressCallBack}) async {
    BaseOptions options = new BaseOptions();

    options.contentType="image/jpg";//"application/octet-stream";
    options.responseType =
        ResponseType.plain; //必须,否则上传失败后aliyun返回的提示信息(非JSON格式)看不到
    //创建一个formdata，作为dio的参数
    File file = new File(filePath);
    FormData data = new FormData.fromMap({
      'Filename': uploadName, //文件名，随意
      'key': "image/"+uploadName, //"可以填写文件夹名（对应于oss服务中的文件夹）/" + fileName
      'policy': OssUtil.policy,
      'OSSAccessKeyId': OssUtil.accesskeyId,
      //Bucket 拥有者的AccessKeyId。
      'success_action_status': '200',
      //让服务端返回200，不然，默认会返回204
      'signature': OssUtil.instance.getSignature(OssUtil.accessKeySecret),
      'x-oss-security-token': OssUtil.stsToken,
      //临时用户授权时必须，需要携带后台返回的security-token
      'file': await MultipartFile.fromFile(
          file.path, filename: OssUtil.instance.getImageNameByPath(filePath))
      //必须放在参数最后
    });
    Dio dio = Dio(options);
    Response response = await dio.post(AliOssAPI.urlUploadImageOss, data: data,onSendProgress: (received, total) {
      onSendProgressCallBack(received, total);
    });

      return response.data;
  }
}