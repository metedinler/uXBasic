/* uxraylib raymath core (S-052, raylib Models/3D dilimi 1): CPU-only math support -- no window / GL context needed.
 *
 * uXBasic's CALL(DLL) carries numbers, not structs, so:
 *   - a Vector2/3/4 or Quaternion RESULT is written to a numbered result REGISTER (0..3) and read with
 *     uxraylib_res_get(reg, component) (component 0=x 1=y 2=z 3=w). Plain results use register 0; functions with
 *     several results (OrthoNormalize, MatrixDecompose) also fill registers 1 and 2;
 *   - a Matrix is a HANDLE (small integer, 0 = invalid) into a pool of UX_MAX_MATRICES matrices; every function that
 *     produces a matrix returns a NEW handle, released with uxraylib_matrix_release;
 *   - a function that would need more than 10 numeric arguments reads its vectors from numbered SLOTS
 *     (uxraylib_vector_slot_set) instead.
 * An invalid matrix handle behaves as the identity matrix and raises uxraylib_math_last_error() = 1; a full pool
 * returns handle 0 and raises 2. The generated part (uxraylib_math.inc) is produced from raymath.h by
 * tools/library_tools/gen_uxraylib_math.py.
 */
#define RAYMATH_IMPLEMENTATION
#include <raymath.h>

#define UX_MAX_MATRICES 1024
#define UX_MATH_REGS 4
#define UX_MATH_SLOTS 8
static Matrix uxMatrices[UX_MAX_MATRICES];
static unsigned char uxMatrixUsed[UX_MAX_MATRICES];
static int uxMatrixLive = 0;
static double uxMathRegs[UX_MATH_REGS][4];
static double uxMathSlots[UX_MATH_SLOTS][4];
static int uxMathError = 0;

#define V2(a, b) ((Vector2){ (a), (b) })
#define V3(a, b, c) ((Vector3){ (a), (b), (c) })
#define V4(a, b, c, d) ((Vector4){ (a), (b), (c), (d) })

static Matrix uxMatrixGet(int handle)
{
    if (handle > 0 && handle < UX_MAX_MATRICES && uxMatrixUsed[handle]) return uxMatrices[handle];
    uxMathError = 1;
    return MatrixIdentity();
}

static int uxMatrixPut(Matrix m)
{
    for (int i = 1; i < UX_MAX_MATRICES; ++i) {
        if (!uxMatrixUsed[i]) {
            uxMatrices[i] = m;
            uxMatrixUsed[i] = 1;
            uxMatrixLive++;
            return i;
        }
    }
    uxMathError = 2;
    return 0;
}

static void uxSetV4(int reg, Vector4 v)
{
    uxMathRegs[reg][0] = (double)v.x; uxMathRegs[reg][1] = (double)v.y;
    uxMathRegs[reg][2] = (double)v.z; uxMathRegs[reg][3] = (double)v.w;
}
static void uxSetV3(int reg, Vector3 v)
{
    uxMathRegs[reg][0] = (double)v.x; uxMathRegs[reg][1] = (double)v.y;
    uxMathRegs[reg][2] = (double)v.z; uxMathRegs[reg][3] = 0.0;
}
static void uxSetV2(int reg, Vector2 v)
{
    uxMathRegs[reg][0] = (double)v.x; uxMathRegs[reg][1] = (double)v.y;
    uxMathRegs[reg][2] = 0.0; uxMathRegs[reg][3] = 0.0;
}

static Vector3 uxSlotV3(int slot)
{
    if (slot < 0 || slot >= UX_MATH_SLOTS) { uxMathError = 3; slot = 0; }
    return (Vector3){ (float)uxMathSlots[slot][0], (float)uxMathSlots[slot][1], (float)uxMathSlots[slot][2] };
}
static Vector4 uxSlotV4(int slot)
{
    if (slot < 0 || slot >= UX_MATH_SLOTS) { uxMathError = 3; slot = 0; }
    return (Vector4){ (float)uxMathSlots[slot][0], (float)uxMathSlots[slot][1],
                      (float)uxMathSlots[slot][2], (float)uxMathSlots[slot][3] };
}

/* ---- registers, slots, matrix handles ------------------------------------------------------------------------ */
UX_EXPORT double uxraylib_res_get(int reg, int component)
{
    if (reg < 0 || reg >= UX_MATH_REGS || component < 0 || component > 3) return 0.0;
    return uxMathRegs[reg][component];
}
UX_EXPORT double uxraylib_res_x(void) { return uxMathRegs[0][0]; }
UX_EXPORT double uxraylib_res_y(void) { return uxMathRegs[0][1]; }
UX_EXPORT double uxraylib_res_z(void) { return uxMathRegs[0][2]; }
UX_EXPORT double uxraylib_res_w(void) { return uxMathRegs[0][3]; }

UX_EXPORT void uxraylib_vector_slot_set(int slot, double x, double y, double z, double w)
{
    if (slot < 0 || slot >= UX_MATH_SLOTS) { uxMathError = 3; return; }
    uxMathSlots[slot][0] = x; uxMathSlots[slot][1] = y; uxMathSlots[slot][2] = z; uxMathSlots[slot][3] = w;
}

UX_EXPORT int uxraylib_math_last_error(void) { return uxMathError; }
UX_EXPORT void uxraylib_math_clear_error(void) { uxMathError = 0; }

UX_EXPORT void uxraylib_matrix_release(int handle)
{
    if (handle > 0 && handle < UX_MAX_MATRICES && uxMatrixUsed[handle]) {
        uxMatrixUsed[handle] = 0;
        uxMatrixLive--;
    }
}
UX_EXPORT int uxraylib_matrix_live_count(void) { return uxMatrixLive; }
UX_EXPORT int uxraylib_matrix_copy(int handle) { return uxMatrixPut(uxMatrixGet(handle)); }

/* index 0..15 follows raylib's field order m0 m4 m8 m12 / m1 m5 m9 m13 / m2 m6 m10 m14 / m3 m7 m11 m15:
   element (row r, column c) is index c*4 + r. */
UX_EXPORT double uxraylib_matrix_element(int handle, int index)
{
    if (index < 0 || index > 15) return 0.0;
    Matrix m = uxMatrixGet(handle);
    float cells[16];
    memcpy(cells, &m, sizeof(cells));
    return (double)cells[index];
}
UX_EXPORT int uxraylib_matrix_set_element(int handle, int index, double value)
{
    if (handle <= 0 || handle >= UX_MAX_MATRICES || !uxMatrixUsed[handle]) { uxMathError = 1; return 0; }
    if (index < 0 || index > 15) return 0;
    float cells[16];
    memcpy(cells, &uxMatrices[handle], sizeof(cells));
    cells[index] = (float)value;
    memcpy(&uxMatrices[handle], cells, sizeof(cells));
    return 1;
}

/* ---- functions the generator cannot express (pointers / structs / more than 10 arguments) -------------------- */
/* Vector3OrthoNormalize: results in register 0 (v1) and register 1 (v2). */
UX_EXPORT void uxraylib_vector3_ortho_normalize(double v1x, double v1y, double v1z, double v2x, double v2y, double v2z)
{
    Vector3 a = V3((float)v1x, (float)v1y, (float)v1z);
    Vector3 b = V3((float)v2x, (float)v2y, (float)v2z);
    Vector3OrthoNormalize(&a, &b);
    uxSetV3(0, a);
    uxSetV3(1, b);
}

/* QuaternionToAxisAngle: returns the angle (radians); the axis is in register 0. */
UX_EXPORT double uxraylib_quaternion_to_axis_angle(double qx, double qy, double qz, double qw)
{
    Vector3 axis = { 0.0f, 0.0f, 0.0f };
    float angle = 0.0f;
    QuaternionToAxisAngle(V4((float)qx, (float)qy, (float)qz, (float)qw), &axis, &angle);
    uxSetV3(0, axis);
    return (double)angle;
}

/* MatrixDecompose: register 0 = translation, register 1 = rotation quaternion, register 2 = scale. */
UX_EXPORT void uxraylib_matrix_decompose(int handle)
{
    Vector3 translation, scale;
    Quaternion rotation;
    MatrixDecompose(uxMatrixGet(handle), &translation, &rotation, &scale);
    uxSetV3(0, translation);
    uxSetV4(1, rotation);
    uxSetV3(2, scale);
}

/* slot variants of the functions that exceed the 10-argument CALL(DLL) limit */
UX_EXPORT void uxraylib_vector3_cubic_hermite_slots(int v1, int tangent1, int v2, int tangent2, double amount)
{
    uxSetV3(0, Vector3CubicHermite(uxSlotV3(v1), uxSlotV3(tangent1), uxSlotV3(v2), uxSlotV3(tangent2), (float)amount));
}
UX_EXPORT void uxraylib_vector3_barycenter_slots(int p, int a, int b, int c)
{
    uxSetV3(0, Vector3Barycenter(uxSlotV3(p), uxSlotV3(a), uxSlotV3(b), uxSlotV3(c)));
}
UX_EXPORT void uxraylib_quaternion_cubic_hermite_spline_slots(int q1, int outTangent1, int q2, int inTangent2, double t)
{
    uxSetV4(0, QuaternionCubicHermiteSpline(uxSlotV4(q1), uxSlotV4(outTangent1), uxSlotV4(q2), uxSlotV4(inTangent2), (float)t));
}

#include "uxraylib_math.inc"
