open Ecore_evas

open Ctypes
let initialize_subsystem () =
  if (ecore_evas_init () != 0) then
    print_endline "Ecore Evas initialized"
  else
    print_endline "Unable to initialize Ecore Evas system"

let  () =
  initialize_subsystem ();
  print_endline "Creating ee";
  let ee = ecore_evas_new (from_voidp char null) 50 50 300 300 (from_voidp char null) in
  ecore_evas_title_set ee "This is a test";
  ecore_evas_alpha_set ee 1;
  print_endline "Showing ee";
  ecore_evas_show ee;
  ecore_main_loop_begin ();
  ecore_evas_free ee;
  ignore(ecore_evas_shutdown ())
