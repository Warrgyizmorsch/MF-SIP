import 'package:equatable/equatable.dart';

import '../../data/model/file_upload_model.dart';

class FileEntity extends Equatable {
  final int? id;
  final String? filetype;
  final int? size;
  final String? directURL;
  final bool? protected;

  const FileEntity({
    this.id,
    this.filetype,
    this.size,
    this.directURL,
    this.protected,
  });

  @override
  List<Object?> get props => [
    id,
    filetype,
    size,
    directURL,
    protected,
  ];
}
extension FileResponseModelMapper on FileResponseModel {
  FileEntity toEntity() {
    return FileEntity(
      id: file?.id,
      filetype: file?.filetype,
      size: file?.size,
      directURL: file?.directURL,
      protected: file?.protected,
    );
  }
}
