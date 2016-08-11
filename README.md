# Using FFI with OCaml

In the [Chap 19 Foreign Function Interface](https://realworldocaml.org/v1/en/html/foreign-function-interface.html) of
the book Real World OCaml, the authors use the library NCurse as example.

Here I use Ecore / Evas from the [Enlightenment Libraries](https://www.enlightenment.org/) know as E.F.L.

## Presentation of the C library.

### The C functions to use :

  * void ecore_main_loop_quit(void)
  * void ecore_main_loop_begin(void)
  * int ecore_evas_init(void)
  * int ecore_evas_shutdown(void)
  * Ecore_Evas * ecore_evas_new(const char *, int, int, int, int, const char *)
  * ecore_evas_title_set(const Ecore_Evas *, const char *);
  * ecore_evas_alpah_set(const Ecore_Evas *, Eina_Bool)
  * ecore_evas_show(ee);
  * ecore_evas_free(ee);

### The code to reproduce

It is just a little transparent window.

```c
/* Compile with:
 * Normal shell (bash, sh, zsh):
 * gcc $(pkg-config --libs --cflags ecore-evas ecore) -o evas_ecore_window_c evas_ecore_window.c
 * Fish shell:
 * eval gcc (pkg-config --libs --cflags ecore-evas ecore) -o evas_ecore_window_c evas_ecore_window.c
 */
#include <stdio.h>
#include <stdlib.h>

#include <Ecore.h>
#include <Ecore_Evas.h>

int main(int argc, char **argv)
{
    if(!ecore_evas_init())
        return EXIT_FAILURE;

    Ecore_Evas * window;
    Evas *canevas;

    window = ecore_evas_new(NULL, 10, 10, 320, 320, NULL);
    if(!window)
        return EXIT_FAILURE;

    ecore_evas_alpha_set(window, EINA_TRUE);
    ecore_evas_show(window);
    ecore_main_loop_begin();
    ecore_evas_free(window);

    ecore_evas_shutdown();

    return EXIT_SUCCESS;
}
```

## Create the OCaml bindings:

###  The Ecore_evas module : simple implementation

*  ecore_evas.ml

```ocaml
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
  foreign "ecore_evas_new" (ptr char @-> int @-> int @-> int @-> int @-> ptr char @-> returning ecore_evas)
let ecore_evas_title_set =
  foreign "ecore_evas_title_set" (ecore_evas @-> string @-> returning void)
let ecore_evas_show =
  foreign "ecore_evas_show" (ecore_evas @-> returning void)
let ecore_evas_free =
  foreign "ecore_evas_free" (ecore_evas @-> returning void)
let ecore_evas_alpha_set =
  foreign "ecore_evas_alpha_set" (ecore_evas @-> int @-> returning void)
```

We generate the module interface file from the module.

```bash
corebuild -pkg ctypes.foreign ecore_evas.inferred.mli
cp _build/ecore_evas.inferred.mli ./
```

#### The main ocaml file

```ocaml
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
```

This file can be build and run with:

```bash
corebuild -pkg ctypes.foreign -lflags -cclib,-lecore_evas -lflags -cclib,-lecore ecore_evas_window.native
./ecore_evas_window.native
```

### The Ecore_evas module :  a more subtle implementation:

#### the string_opt type

Previously when I needed to pass a C `char *` I used in the OCaml bindings both
`char ptr` and `string`. That is because I wanted to use Null pointers in the
function `ecore_evas_new`. In Ctypes there is the type `string_opt` which can
support a pointer of char and a Null pointer.
