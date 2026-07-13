class MediaModel {
  final String id;
  final String originalFileName;
  final String mimeType;
  final String extension;
  final int fileSize;
  final String storagePath;
  final String checksum;
  final DateTime uploadedAt;
  final String uploadedByUserId;
  final String status;
  final String? thumbnailPath;
  final int? width;
  final int? height;
  final double? duration;
  final String? processingError;

  MediaModel({
    required this.id,
    required this.originalFileName,
    required this.mimeType,
    required this.extension,
    required this.fileSize,
    required this.storagePath,
    required this.checksum,
    required this.uploadedAt,
    required this.uploadedByUserId,
    required this.status,
    this.thumbnailPath,
    this.width,
    this.height,
    this.duration,
    this.processingError,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'],
      originalFileName: json['originalFileName'],
      mimeType: json['mimeType'],
      extension: json['extension'],
      fileSize: json['fileSize'],
      storagePath: json['storagePath'],
      checksum: json['checksum'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
      uploadedByUserId: json['uploadedByUserId'],
      status: json['status']?.toString() ?? 'Uploaded',
      thumbnailPath: json['thumbnailPath'],
      width: json['width'],
      height: json['height'],
      duration: json['duration'] != null ? (json['duration'] as num).toDouble() : null,
      processingError: json['processingError'],
    );
  }
}
