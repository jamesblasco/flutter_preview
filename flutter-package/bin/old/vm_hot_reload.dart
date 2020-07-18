// import 'dart:developer' as dev;

// import 'package:vm_service/utils.dart' as vms_utils;
// import 'package:vm_service/vm_service.dart' as vms;
// import 'package:vm_service/vm_service_io.dart' as vms_io;
// import 'dart:io' as io;
// import 'dart:isolate' as isolate;
// import 'package:path/path.dart' as p;

// vms.VmService _vmService;

// Future<vms.VmService> _getVmService() async {
//   if (_vmService == null) {
//     final devServiceURL = (await dev.Service.getInfo()).serverUri;
//     if (devServiceURL == null) {
//       throw new StateError(
//           'VM service not available! You need to run dart with --enable-vm-service.');
//     }
//     final wsURL =
//         vms_utils.convertToWebSocketUrl(serviceProtocolUrl: devServiceURL);

//     _vmService = await vms_io.vmServiceConnectUri(wsURL.toString());
//   }
//   return _vmService;
// }

// Future restart() async {
//   if (_vmService == null) await _getVmService();
//   final vm = await _vmService.getVM();

//   final isolates = vm.isolates;

//   for (final isolate in isolates) {
//     final reloadReport = await _vmService.reloadSources(isolate.id,
//         force: true, packagesUri: null);
//     print(reloadReport);
//   }
// }

// io.File _packagesFile;
// Future<io.File> get packagesFile async {
//   if (_packagesFile == null) {
//     final path =
//         (await isolate.Isolate.packageConfig)?.toFilePath() ?? '.packages';
//     _packagesFile = new io.File(path).absolute;
//   }
//   return _packagesFile;
// }

// io.Directory _pubCacheDir;
// io.Directory get pubCacheDir {
//   if (_pubCacheDir == null) {
//     final env = io.Platform.environment;
//     final path = //
//         env.containsKey('PUB_CACHE')
//             ? env['PUB_CACHE']
//             : io.Platform.isWindows
//                 ? p.join(env['APPDATA'], 'Pub', 'Cache')
//                 : '${env['HOME']}/.pub-cache';
//     _pubCacheDir = new io.Directory(p.normalize(path)).absolute;
//   }
//   return _pubCacheDir;
// }
