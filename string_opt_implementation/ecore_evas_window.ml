open Ecore_evas
(* compile with:
  * corebuild -pkg ctypes.foreign -lflags -cclib,-lecore_evas -lflags -cclib,-lecore ecore_evas_window.native
  *)
open Ctypes
let initialize_subsystem () =
  if (ecore_evas_init () != 0) then
    print_endline "Ecore Evas initialized"
  else
    print_endline "Unable to initialize Ecore Evas system"

let  () =
  initialize_subsystem ();
  print_endline "Creating ee";
  let ee = ecore_evas_new None 50 50 300 300 None in
  ecore_evas_title_set ee (Some "This is a test");
  ecore_evas_alpha_set ee 1;
  print_endline "Showing ee";
  ecore_evas_show ee;
  ecore_main_loop_begin ();
  ecore_evas_free ee;
  ignore(ecore_evas_shutdown ())
