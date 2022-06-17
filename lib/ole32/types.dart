import 'dart:ffi';

import 'package:ffi/ffi.dart';

class GUIDNative extends Struct {
  @Uint32()
  external int data1;
  @Uint16()
  external int data2;
  @Uint16()
  external int data3;
  @Uint8()
  external int data4_0;
  @Uint8()
  external int data4_1;
  @Uint8()
  external int data4_2;
  @Uint8()
  external int data4_3;
  @Uint8()
  external int data4_4;
  @Uint8()
  external int data4_5;
  @Uint8()
  external int data4_6;
  @Uint8()
  external int data4_7;
}

class GUID {
  GUID(
      this.data1,
      this.data2,
      this.data3,
      this.data4_0,
      this.data4_1,
      this.data4_2,
      this.data4_3,
      this.data4_4,
      this.data4_5,
      this.data4_6,
      this.data4_7);

  Pointer<GUIDNative> pointer() {
    final pGuid = calloc<GUIDNative>();
    pGuid.ref.data1 = data1;
    pGuid.ref.data2 = data2;
    pGuid.ref.data3 = data3;
    pGuid.ref.data4_0 = data4_0;
    pGuid.ref.data4_1 = data4_1;
    pGuid.ref.data4_2 = data4_2;
    pGuid.ref.data4_3 = data4_3;
    pGuid.ref.data4_4 = data4_4;
    pGuid.ref.data4_5 = data4_5;
    pGuid.ref.data4_6 = data4_6;
    pGuid.ref.data4_7 = data4_7;
    return pGuid;
  }

  int data1;
  int data2;
  int data3;
  int data4_0;
  int data4_1;
  int data4_2;
  int data4_3;
  int data4_4;
  int data4_5;
  int data4_6;
  int data4_7;
}

class COMObject extends Struct {
  external Pointer<Pointer<IntPtr>> lpVtbl;

  Pointer<IntPtr> get vtable => lpVtbl.value;
}
