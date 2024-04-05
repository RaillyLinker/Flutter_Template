// import 'dart:html';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';

// (파일 URL 에서 파일들을 가져와, zip 으로 압축하여 다운받는 함수)
// 파일 URL 리스트를,
// List<String> fileUrls = [
//   'https://test.com/2024-04-03_17_21_21_116.png',
//   'https://test.com/2024-04-03_17_21_21_112.png',
// ];
//
// downloadFileUrlListZip(fileUrls);
// 위와 같이 넣어주면, 해당 파일들을 압축한 후 로컬에 저장합니다.

void downloadFileUrlListZip(List<String> fileUrls) async {
  // 파일을 다운로드하여 압축할 데이터 목록을 생성합니다.
  List<Uint8List> downloadFutures = [];
  for (String url in fileUrls) {
    final response = await http.get(Uri.parse(url));
    Uint8List download;
    if (response.statusCode == 200) {
      download = response.bodyBytes;
    } else {
      throw Exception('Failed to download file from $url');
    }

    downloadFutures.add(download);
  }
  List<Uint8List> filesData = downloadFutures;

  // 압축

  Archive archive = Archive();
  for (int i = 0; i < filesData.length; i++) {
    String fileUrl = fileUrls[i];
    String fileName = fileUrl.split("/").last;
    var fileNameSplit = fileName.split(".");
    String fileExp;
    if (fileNameSplit.length < 2) {
      fileExp = "";
    } else {
      fileExp = fileNameSplit.last;
    }

    ArchiveFile file =
        ArchiveFile('file$i.$fileExp', filesData[i].length, filesData[i]);
    archive.addFile(file);
  }
  ZipEncoder encoder = ZipEncoder();
  List<int> compressedData = encoder.encode(archive)!;

  // 압축된 데이터를 다운로드할 수 있는 링크를 생성합니다.
  // !!!웹에서 다운받는 함수. 웹 환경에서 import 'dart:html' 과 함께 주석을 풀어주세요.!!!
  // final blob = Blob([Uint8List.fromList(compressedData)]);
  // final url = Url.createObjectUrlFromBlob(blob);
  // final anchor = AnchorElement(href: url)
  //   ..setAttribute('download', 'compressed_files.zip')
  //   ..click();
  // Url.revokeObjectUrl(url);

  print('Compression and download completed.');
}
