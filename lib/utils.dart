import 'package:image_picker/image_picker.dart';

pickvideo()async{
  final picker=ImagePicker();
  XFile? videoFile;
  try{
    videoFile=await picker.pickVideo(source: ImageSource.gallery);
    return videoFile!.path;
  }
  catch(e){
    print('error picking Video: $e');
  }
}
