open Ctypes
open Foreign

let ecore_main_loop_begin =
  foreign "ecore_main_loop_begin" (void @-> returning void)
let ecore_main_loop_quit =
  foreign "ecore_main_loop_quit" (void @-> returning void)
let ecore_evas_init =
  foreign "ecore_evas_init" (void @-> returning int)
let ecore_evas_shutdown =
  foreign "ecore_evas_shutdown" (void @-> returning int)

type ecore_evas = unit ptr
let ecore_evas : ecore_evas typ = ptr void

let ecore_evas_new =
  foreign "ecore_evas_new" (string_opt @-> int @-> int @-> int @-> int @-> string_opt @-> returning ecore_evas)

let ecore_evas_title_set =
  foreign "ecore_evas_title_set" (ecore_evas @-> string_opt @-> returning void)

let ecore_evas_show =
  foreign "ecore_evas_show" (ecore_evas @-> returning void)

let ecore_evas_free =
  foreign "ecore_evas_free" (ecore_evas @-> returning void)

let ecore_evas_alpha_set =
  foreign "ecore_evas_alpha_set" (ecore_evas @-> int @-> returning void)
