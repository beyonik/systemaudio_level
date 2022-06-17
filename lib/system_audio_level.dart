import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:system_audio_level/ole32/ffi.dart';
import 'package:system_audio_level/util/dylib_wrapper.dart';
import 'package:system_audio_level/util/windows_path.dart';

import 'ole32/types.dart';

class SystemAudioLevel {
  static final _CLSID_MMDeviceEnumerator = GUID(0xbcde0395, 0xe52f, 0x467c,
      0x8e, 0x3d, 0xc4, 0x57, 0x92, 0x91, 0x69, 0x2e);
  static final _IID_IMMDeviceEnumerator = GUID(0xa95664d2, 0x9614, 0x4f35, 0xa7,
      0x46, 0xde, 0x8d, 0xb6, 0x36, 0x17, 0xe6);
  static final _IID_IAudioMeterInformation = GUID(0xC02216F6, 0x8C67, 0x4B5B,
      0x9D, 0x00, 0xD0, 0x08, 0xE7, 0x3E, 0x00, 0x64);

  static final _devEnumerator = calloc<COMObject>();
  static final _meterDevice = calloc<Pointer<COMObject>>();
  static final _meterInfo = calloc<Pointer<COMObject>>();

  static late DynamicLibrary? _ole32;
  static DynamicLibrary get ole32 => _ole32!;

  static void initialize() {
    _ole32 = load_dylib("${getWindowsFolder()}/System32/ole32.dll");
    COMFFI.CoInitializeEx(0x2); // COINIT_APARTMENTTHREADED

    COMFFI.CoCreateInstance(
      _CLSID_MMDeviceEnumerator,
      23, // CLSCTX_ALL
      _IID_IMMDeviceEnumerator,
      _devEnumerator,
    );

    _GetDefaultAudioEndpoint(_devEnumerator, 0, 0, _meterDevice);
    final guid = _IID_IAudioMeterInformation.pointer();
    _Activate(_meterDevice.cast(), guid, 23, Pointer<Void>.fromAddress(0),
        _meterInfo);
  }

  static double getAmplitude() =>
      _meterInfo.address != 0 ? _GetPeakValue(_meterInfo.cast()) : 0.0;

  static double _GetPeakValue(Pointer<COMObject> audioMeterInfo) {
    final function = audioMeterInfo.ref.vtable
        .elementAt(3)
        .cast<
            Pointer<
                NativeFunction<IntPtr Function(Pointer, Pointer<Float> out)>>>()
        .value
        .asFunction<int Function(Pointer, Pointer<Float> out)>();
    final peak = calloc<Float>();
    final hr = function(audioMeterInfo.ref.lpVtbl, peak);
    final ret = peak.value;
    calloc.free(peak);
    return ret;
  }

  static int _GetDefaultAudioEndpoint(Pointer<COMObject> devEnumerator,
      int dataFlow, int role, Pointer<Pointer<COMObject>> ppDevice) {
    final function = devEnumerator.ref.vtable
        .elementAt(4)
        .cast<
            Pointer<
                NativeFunction<
                    Int32 Function(Pointer, Int32 dataFlow, Int32 role,
                        Pointer<Pointer<COMObject>> ppEndpoint)>>>()
        .value
        .asFunction<
            int Function(Pointer, int dataFlow, int role,
                Pointer<Pointer<COMObject>> ppEndpoint)>();

    final hr = function(devEnumerator.ref.lpVtbl, dataFlow, role, ppDevice);
    return hr;
  }

  static int _Release(Pointer<COMObject> interface) => interface.ref.vtable
      .elementAt(2)
      .cast<Pointer<NativeFunction<Uint32 Function(Pointer)>>>()
      .value
      .asFunction<int Function(Pointer)>()(interface.ref.lpVtbl);

  static int _Activate(
          Pointer<COMObject> device,
          Pointer<GUIDNative> iid,
          int dwClsCtx,
          Pointer<Void> pActivationParams,
          Pointer<Pointer> ppInterface) =>
      device.ref.vtable
              .elementAt(3)
              .cast<
                  Pointer<
                      NativeFunction<
                          Int32 Function(
                              Pointer,
                              Pointer<GUIDNative> iid,
                              Uint32 dwClsCtx,
                              Pointer<Void> pActivationParams,
                              Pointer<Pointer> ppInterface)>>>()
              .value
              .asFunction<
                  int Function(
                      Pointer,
                      Pointer<GUIDNative> iid,
                      int dwClsCtx,
                      Pointer<Void> pActivationParams,
                      Pointer<Pointer> ppInterface)>()(
          device.ref.lpVtbl, iid, dwClsCtx, pActivationParams, ppInterface);

  static void dispose() {
    _Release(_meterInfo.cast());
    _Release(_meterDevice.cast());
    _Release(_devEnumerator.cast());
    calloc.free(_meterDevice);
    calloc.free(_devEnumerator);
    calloc.free(_meterInfo);
    COMFFI.CoUninitialize();
  }
}
