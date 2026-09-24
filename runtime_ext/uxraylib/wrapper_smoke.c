#include <math.h>
#include <stdio.h>

__declspec(dllimport) int uxraylib_adapter_version(void);
__declspec(dllimport) const char *uxraylib_raylib_version(void);
__declspec(dllimport) const char *uxraylib_raygui_version(void);
__declspec(dllimport) unsigned int uxraylib_color_rgba(int, int, int, int);
__declspec(dllimport) double uxraylib_rectangle_area(double, double);
__declspec(dllimport) int uxsdl3_adapter_version(void);
__declspec(dllimport) int uxsdl3_runtime_version(void);

int main(void)
{
    double area = uxraylib_rectangle_area(12.0f, 5.0f);
    unsigned int color = uxraylib_color_rgba(1, 2, 3, 4);
    printf("ADAPTER=%d\n", uxraylib_adapter_version());
    printf("RAYLIB=%s\n", uxraylib_raylib_version());
    printf("RAYGUI=%s\n", uxraylib_raygui_version());
    printf("AREA=%.1f\n", area);
    printf("COLOR=%08X\n", color);
    printf("SDL_ADAPTER=%d\n", uxsdl3_adapter_version());
    printf("SDL_RUNTIME=%d\n", uxsdl3_runtime_version());
    return (uxraylib_adapter_version() == 100 &&
            uxsdl3_adapter_version() == 100 &&
            fabs(area - 60.0) < 0.001 &&
            color == 0x04030201u) ? 0 : 1;
}
