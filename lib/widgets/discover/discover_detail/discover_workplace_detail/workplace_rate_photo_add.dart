import 'dart:io';
import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/photo_picker_sheet.dart';
import 'package:Wetieko/managers/photo_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkplaceRatePhotoAdd extends StatefulWidget {
  final File? photo;
  final Function(File?) onPhotoChanged;

  const WorkplaceRatePhotoAdd({
    super.key,
    required this.photo,
    required this.onPhotoChanged,
  });

  @override
  State<WorkplaceRatePhotoAdd> createState() => _WorkplaceRatePhotoAddState();
}

class _WorkplaceRatePhotoAddState extends State<WorkplaceRatePhotoAdd> {
  final PhotoManager _photoManager = PhotoManager();

  void _showPhotoPickerSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return PhotoPickerSheet(
          onPickGallery: () async {
            Navigator.pop(context);
            final photo = await _photoManager.pickFromGallery();
            if (photo != null) widget.onPhotoChanged(photo);
          },
          onPickCamera: () async {
            Navigator.pop(context);
            final photo = await _photoManager.pickFromCamera();
            if (photo != null) widget.onPhotoChanged(photo);
          },
          onDelete: () {
            Navigator.pop(context);
            widget.onPhotoChanged(null);
          },
          onClose: () => Navigator.pop(context),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.neutralGrey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.addPhoto,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.neutralDark,
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _showPhotoPickerSheet,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(12),
                image: widget.photo != null
                    ? DecorationImage(
                        image: FileImage(widget.photo!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: AppColors.neutralLight,
              ),
              child: widget.photo == null
                  ? const Center(
                      child: Icon(Icons.add, size: 30, color: AppColors.primary),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
