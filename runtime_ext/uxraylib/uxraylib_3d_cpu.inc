/* uxraylib 3D geometry that needs no window / GL context (S-052, raylib Models/3D dilimi 2):
 * sphere/box/ray collision, camera handles, world<->screen projection. Builds on uxraylib_math_core.inc
 * (vector registers, vector slots, matrix handles).
 *
 *   - a Ray is two vector SLOTS (position slot, direction slot); a BoundingBox is two slots (min slot, max slot);
 *     a triangle/quad corner is one slot each (fill them with uxraylib_vector_slot_set);
 *   - a ray-collision RESULT (RayCollision) lands in a result block read with uxraylib_ray_hit / _distance / _point /
 *     _normal;
 *   - a Camera3D is a HANDLE (pool of UX_MAX_CAMERAS); its parts are read back with uxraylib_camera_get.
 */
#define UX_MAX_CAMERAS 32
static Camera3D uxCameras[UX_MAX_CAMERAS];
static unsigned char uxCameraUsed[UX_MAX_CAMERAS];
static RayCollision uxRayCol;

static Ray uxSlotRay(int posSlot, int dirSlot)
{
    Ray ray;
    ray.position = uxSlotV3(posSlot);
    ray.direction = uxSlotV3(dirSlot);
    return ray;
}
static BoundingBox uxSlotBox(int minSlot, int maxSlot)
{
    BoundingBox box;
    box.min = uxSlotV3(minSlot);
    box.max = uxSlotV3(maxSlot);
    return box;
}
static Camera3D uxCameraGet(int handle)
{
    if (handle > 0 && handle < UX_MAX_CAMERAS && uxCameraUsed[handle]) return uxCameras[handle];
    uxMathError = 4;
    Camera3D empty;
    memset(&empty, 0, sizeof(empty));
    empty.up.y = 1.0f;
    empty.fovy = 45.0f;
    empty.projection = CAMERA_PERSPECTIVE;
    return empty;
}

/* ---- collision ------------------------------------------------------------------------------------------------ */
UX_EXPORT int uxraylib_check_collision_spheres(double c1x, double c1y, double c1z, double r1,
                                               double c2x, double c2y, double c2z, double r2)
{
    return CheckCollisionSpheres(V3((float)c1x, (float)c1y, (float)c1z), (float)r1,
                                 V3((float)c2x, (float)c2y, (float)c2z), (float)r2);
}
UX_EXPORT int uxraylib_check_collision_boxes_slots(int min1, int max1, int min2, int max2)
{
    return CheckCollisionBoxes(uxSlotBox(min1, max1), uxSlotBox(min2, max2));
}
UX_EXPORT int uxraylib_check_collision_box_sphere_slots(int minSlot, int maxSlot, double cx, double cy, double cz, double radius)
{
    return CheckCollisionBoxSphere(uxSlotBox(minSlot, maxSlot), V3((float)cx, (float)cy, (float)cz), (float)radius);
}

UX_EXPORT int uxraylib_ray_collision_sphere_slots(int posSlot, int dirSlot, double cx, double cy, double cz, double radius)
{
    uxRayCol = GetRayCollisionSphere(uxSlotRay(posSlot, dirSlot), V3((float)cx, (float)cy, (float)cz), (float)radius);
    return uxRayCol.hit ? 1 : 0;
}
UX_EXPORT int uxraylib_ray_collision_box_slots(int posSlot, int dirSlot, int minSlot, int maxSlot)
{
    uxRayCol = GetRayCollisionBox(uxSlotRay(posSlot, dirSlot), uxSlotBox(minSlot, maxSlot));
    return uxRayCol.hit ? 1 : 0;
}
UX_EXPORT int uxraylib_ray_collision_triangle_slots(int posSlot, int dirSlot, int p1, int p2, int p3)
{
    uxRayCol = GetRayCollisionTriangle(uxSlotRay(posSlot, dirSlot), uxSlotV3(p1), uxSlotV3(p2), uxSlotV3(p3));
    return uxRayCol.hit ? 1 : 0;
}
UX_EXPORT int uxraylib_ray_collision_quad_slots(int posSlot, int dirSlot, int p1, int p2, int p3, int p4)
{
    uxRayCol = GetRayCollisionQuad(uxSlotRay(posSlot, dirSlot), uxSlotV3(p1), uxSlotV3(p2), uxSlotV3(p3), uxSlotV3(p4));
    return uxRayCol.hit ? 1 : 0;
}
UX_EXPORT int uxraylib_ray_hit(void) { return uxRayCol.hit ? 1 : 0; }
UX_EXPORT double uxraylib_ray_distance(void) { return (double)uxRayCol.distance; }
/* component 0=x 1=y 2=z */
UX_EXPORT double uxraylib_ray_point(int component)
{
    switch (component) { case 0: return (double)uxRayCol.point.x; case 1: return (double)uxRayCol.point.y; case 2: return (double)uxRayCol.point.z; }
    return 0.0;
}
UX_EXPORT double uxraylib_ray_normal(int component)
{
    switch (component) { case 0: return (double)uxRayCol.normal.x; case 1: return (double)uxRayCol.normal.y; case 2: return (double)uxRayCol.normal.z; }
    return 0.0;
}

/* ---- Camera3D handles ------------------------------------------------------------------------------------------ */
/* projection: 0 = CAMERA_PERSPECTIVE, 1 = CAMERA_ORTHOGRAPHIC (raylib's own values are 0 and 1). */
UX_EXPORT int uxraylib_camera_create(int posSlot, int targetSlot, int upSlot, double fovy, int projection)
{
    for (int i = 1; i < UX_MAX_CAMERAS; ++i) {
        if (!uxCameraUsed[i]) {
            uxCameras[i].position = uxSlotV3(posSlot);
            uxCameras[i].target = uxSlotV3(targetSlot);
            uxCameras[i].up = uxSlotV3(upSlot);
            uxCameras[i].fovy = (float)fovy;
            uxCameras[i].projection = projection == 1 ? CAMERA_ORTHOGRAPHIC : CAMERA_PERSPECTIVE;
            uxCameraUsed[i] = 1;
            return i;
        }
    }
    uxMathError = 2;
    return 0;
}
UX_EXPORT void uxraylib_camera_release(int handle)
{
    if (handle > 0 && handle < UX_MAX_CAMERAS) uxCameraUsed[handle] = 0;
}
UX_EXPORT int uxraylib_camera_valid(int handle)
{
    return (handle > 0 && handle < UX_MAX_CAMERAS && uxCameraUsed[handle]) ? 1 : 0;
}
/* part: 0 position, 1 target, 2 up (component 0..2 = x y z); part 3 = fovy (component ignored); part 4 = projection */
UX_EXPORT double uxraylib_camera_get(int handle, int part, int component)
{
    Camera3D camera = uxCameraGet(handle);
    Vector3 v = { 0.0f, 0.0f, 0.0f };
    switch (part) {
        case 0: v = camera.position; break;
        case 1: v = camera.target; break;
        case 2: v = camera.up; break;
        case 3: return (double)camera.fovy;
        case 4: return (double)camera.projection;
        default: return 0.0;
    }
    switch (component) { case 0: return (double)v.x; case 1: return (double)v.y; case 2: return (double)v.z; }
    return 0.0;
}
UX_EXPORT void uxraylib_camera_set(int handle, int part, double x, double y, double z)
{
    if (!uxraylib_camera_valid(handle)) { uxMathError = 4; return; }
    switch (part) {
        case 0: uxCameras[handle].position = V3((float)x, (float)y, (float)z); break;
        case 1: uxCameras[handle].target = V3((float)x, (float)y, (float)z); break;
        case 2: uxCameras[handle].up = V3((float)x, (float)y, (float)z); break;
        case 3: uxCameras[handle].fovy = (float)x; break;
        case 4: uxCameras[handle].projection = ((int)x) == 1 ? CAMERA_ORTHOGRAPHIC : CAMERA_PERSPECTIVE; break;
        default: break;
    }
}
/* UpdateCameraPro: movement (forward, right, up), rotation (yaw, pitch, roll in degrees), zoom (distance change). */
UX_EXPORT void uxraylib_camera_update_pro(int handle, double moveForward, double moveRight, double moveUp,
                                          double yaw, double pitch, double roll, double zoom)
{
    if (!uxraylib_camera_valid(handle)) { uxMathError = 4; return; }
    UpdateCameraPro(&uxCameras[handle], V3((float)moveForward, (float)moveRight, (float)moveUp),
                    V3((float)yaw, (float)pitch, (float)roll), (float)zoom);
}
/* view matrix (raylib GetCameraMatrix); returns a matrix handle */
UX_EXPORT int uxraylib_camera_matrix(int handle) { return uxMatrixPut(GetCameraMatrix(uxCameraGet(handle))); }

/* GetWorldToScreenEx: register 0 = (x, y) in pixels for a window of width x height */
UX_EXPORT void uxraylib_world_to_screen(int handle, double px, double py, double pz, int width, int height)
{
    uxSetV2(0, GetWorldToScreenEx(V3((float)px, (float)py, (float)pz), uxCameraGet(handle), width, height));
}
/* GetScreenToWorldRayEx: register 0 = ray origin, register 1 = ray direction */
UX_EXPORT void uxraylib_screen_to_world_ray(int handle, double sx, double sy, int width, int height)
{
    Ray ray = GetScreenToWorldRayEx(V2((float)sx, (float)sy), uxCameraGet(handle), width, height);
    uxSetV3(0, ray.position);
    uxSetV3(1, ray.direction);
}
