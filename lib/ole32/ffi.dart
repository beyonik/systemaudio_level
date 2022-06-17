import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:system_audio_level/ole32/types.dart';
import 'package:system_audio_level/system_audio_level.dart';

typedef CoInitializeExNative = IntPtr Function(
    Pointer<Void> pvReserved, IntPtr dwCoInit);
typedef CoInitializeExDart = int Function(
    Pointer<Void> pvReserved, int dwCoInit);

typedef CoUninitializeNative = Void Function();
typedef CoUninitializeDart = void Function();

typedef CoCreateInstanceNative = IntPtr Function(
    Pointer<GUIDNative> rclsid,
    Pointer<Void> pUnkOuter,
    IntPtr dwClsContext,
    Pointer<GUIDNative> riid,
    Pointer<COMObject> ppv);
typedef CoCreateInstanceDart = int Function(
    Pointer<GUIDNative> rclsid,
    Pointer<Void> pUnkOuter,
    int dwClsContext,
    Pointer<GUIDNative> riid,
    Pointer<COMObject> ppv);

class COMFFI {
  static CoInitializeEx(int dwCoInit) => SystemAudioLevel.ole32
      .lookupFunction<CoInitializeExNative, CoInitializeExDart>(
          "CoInitializeEx")(Pointer<Void>.fromAddress(0), dwCoInit);

  static int CoCreateInstance(
      GUID guid, int dwClsContext, GUID riid, Pointer<COMObject> ppv) {
    final guidPtr = guid.pointer();
    final riidPtr = riid.pointer();
    final retn = SystemAudioLevel.ole32
            .lookupFunction<CoCreateInstanceNative, CoCreateInstanceDart>(
                "CoCreateInstance")(
        guidPtr, Pointer<Void>.fromAddress(0), dwClsContext, riidPtr, ppv);

    calloc.free(guidPtr);
    calloc.free(riidPtr);
    return retn;
  }

  static CoUninitialize() => SystemAudioLevel.ole32
      .lookupFunction<CoUninitializeNative, CoUninitializeDart>(
          "CoUninitialize")();
}
