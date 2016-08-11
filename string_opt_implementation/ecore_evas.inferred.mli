val ecore_main_loop_begin : unit -> unit
val ecore_main_loop_quit : unit -> unit
val ecore_evas_init : unit -> int
val ecore_evas_shutdown : unit -> int
type ecore_evas = unit Ctypes.ptr
val ecore_evas : ecore_evas Ctypes_static.typ
val ecore_evas_new :
  bytes option -> int -> int -> int -> int -> bytes option -> ecore_evas
val ecore_evas_title_set : ecore_evas -> bytes option -> unit
val ecore_evas_show : ecore_evas -> unit
val ecore_evas_free : ecore_evas -> unit
val ecore_evas_alpha_set : ecore_evas -> int -> unit
