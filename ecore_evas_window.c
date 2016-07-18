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
