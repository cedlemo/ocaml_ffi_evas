(* corebuild -pkg ctypes.foreign,ctypes.stubs -lflags -cclib,-lecore_evas -lflags -cclib,-lecore stubs_generator.native *)
let _ =
  let prefix = "ecore_evas_stubs" in
  let generate_ml, generate_c = ref false, ref false in
  Arg.(parse [ ("-ml", Set generate_ml, "Generate ML");
                ("-c", Set generate_c, "Generate C") ])
    (fun _ -> failwith "unexpected anonymous argument")
    "stubgen [-ml|-c]";
  match !generate_ml, !generate_c with
  | false, false
  | true, true ->
    failwith "Exactly one of -ml and -c must be specified"
  | true, false ->
    Cstubs.write_ml Format.std_formatter ~prefix (module Ecore_evas.Bindings)
  | false, true ->
      print_endline "#include <Ecore.h>\n#include <Ecore_Evas.h>";
    Cstubs.write_c Format.std_formatter ~prefix (module Ecore_evas.Bindings)

