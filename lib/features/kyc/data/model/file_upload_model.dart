import '../../../../core/utils/helper/custom_json_parser.dart';

class FileResponseModel {
  final FileModel? file;

  const FileResponseModel({
    this.file,
  });

  factory FileResponseModel.fromJson(Map<String, dynamic> json) {
    return FileResponseModel(
      file: json.parseNested<FileModel>(
        'file',
            (map) => FileModel.fromJson(map),
      ),
    );
  }
}
class FileModel {
  final int? id;
  final String? filetype;
  final int? size;
  final String? directURL;
  final bool? protected;

  const FileModel({
    this.id,
    this.filetype,
    this.size,
    this.directURL,
    this.protected,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json.parse<int>('id'),
      filetype: json.parse<String>('filetype'),
      size: json.parse<int>('size'),
      directURL: json.parse<String>('directURL'),
      protected: json.parse<bool>('protected'),
    );
  }
}
