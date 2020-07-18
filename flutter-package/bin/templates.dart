String generateFile(
  String filePath,
  List<String> providers,
) {
  final import = filePath.replaceFirst('/lib/', '').replaceFirst('lib/', '');
  return '''

import 'package:flutter/widgets.dart';
import 'package:preview/preview.dart';
import '$import';  
void main() {
  runApp(_PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewPage(
      path: '$import',
      providers: () => [
        ${providers.reversed.fold('', (p, e) => e + '(), \n        ' + p)}
      ],
    );
  }
}
  ''';
}

const String notSeeTemplate = '''

import 'package:flutter/widgets.dart';
import 'package:preview/preview.dart';

//
//  
//                            .............       
//                          ************          
//                       .************            
//                     ************               
//                  .************                 
//                ************                    
//             .************                      
//           ************                         
//         ************      ************         
//           *******      ,************           
//             .**      ////********              
//                   *////////****                
//                  ,//////////%%                 
//                     //////%%%%%%               
//                       ,%%%%%%%%%%%%            
//                          %%%%%%%%%%%%  
//
//
//
//

void main() {
  runApp(_PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewPage(
      child: Text('You should not be editing this file 👀')
    );
  }
}
  ''';

const String notValidFormatTemplate = '''

import 'package:flutter/widgets.dart';
import 'package:preview/preview.dart';

void main() {
  runApp(_PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewPage(
      child: Text('This format does not support preview 👀')
      );
  }
}
  ''';

const String notInLibFormatTemplate = '''

import 'package:flutter/widgets.dart';
import 'package:preview/preview.dart';

void main() {
  runApp(_PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewPage(
      child: Text('Select a file from /lib folder to see the preview 👀'),
    );
  }
}
  ''';
