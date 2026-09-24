/* uxraylib 3D drawing, meshes, models, materials, animations (S-052, raylib Models/3D dilimi 3).
 * These need an open window (a GL context): call uxraylib_init_window first (a hidden window works:
 * SetConfigFlags(FLAG_WINDOW_HIDDEN) before InitWindow). Builds on uxraylib_math_core.inc / uxraylib_3d_cpu.inc.
 *
 * Handles are small integers (0 = none/invalid): meshes, models, materials, animation sets. Colors are packed RGBA
 * U32 (r | g<<8 | b<<16 | a<<24, uxraylib_color_rgba). Positions/axes/scales that would push a call over the 10-value
 * CALL(DLL) limit come from vector SLOTS (uxraylib_vector_slot_set); a camera is a Camera3D handle.
 *
 * Ownership: uxraylib_load_model_from_mesh CONSUMES the mesh handle (the model owns the mesh from then on;
 * uxraylib_unload_model frees it). A mesh handle never given to a model is freed with uxraylib_mesh_unload.
 */
#define UX_MAX_MESHES 256
#define UX_MAX_MODELS 128
#define UX_MAX_MATERIALS 256
#define UX_MAX_ANIMSETS 32
static Mesh uxMeshes[UX_MAX_MESHES];
static unsigned char uxMeshUsed[UX_MAX_MESHES];
static Model uxModels[UX_MAX_MODELS];
static unsigned char uxModelUsed[UX_MAX_MODELS];
static Material uxMaterials[UX_MAX_MATERIALS];
static unsigned char uxMaterialUsed[UX_MAX_MATERIALS];
static ModelAnimation *uxAnimSets[UX_MAX_ANIMSETS];
static int uxAnimCounts[UX_MAX_ANIMSETS];
static unsigned char uxAnimUsed[UX_MAX_ANIMSETS];

static int uxMeshOk(int h) { return h > 0 && h < UX_MAX_MESHES && uxMeshUsed[h]; }
static int uxModelOk(int h) { return h > 0 && h < UX_MAX_MODELS && uxModelUsed[h]; }
static int uxMaterialOk(int h) { return h > 0 && h < UX_MAX_MATERIALS && uxMaterialUsed[h]; }
static int uxAnimOk(int h) { return h > 0 && h < UX_MAX_ANIMSETS && uxAnimUsed[h]; }

static int uxMeshStore(Mesh mesh)
{
    for (int i = 1; i < UX_MAX_MESHES; ++i) {
        if (!uxMeshUsed[i]) { uxMeshes[i] = mesh; uxMeshUsed[i] = 1; return i; }
    }
    UnloadMesh(mesh);
    return 0;
}
static int uxModelStore(Model model)
{
    for (int i = 1; i < UX_MAX_MODELS; ++i) {
        if (!uxModelUsed[i]) { uxModels[i] = model; uxModelUsed[i] = 1; return i; }
    }
    UnloadModel(model);
    return 0;
}
static int uxMaterialStore(Material material)
{
    for (int i = 1; i < UX_MAX_MATERIALS; ++i) {
        if (!uxMaterialUsed[i]) { uxMaterials[i] = material; uxMaterialUsed[i] = 1; return i; }
    }
    UnloadMaterial(material);
    return 0;
}

/* ---- Camera3D drawing mode ------------------------------------------------------------------------------------- */
UX_EXPORT void uxraylib_begin_mode_3d(int camera) { BeginMode3D(uxCameraGet(camera)); }
UX_EXPORT void uxraylib_end_mode_3d(void) { EndMode3D(); }

/* ---- basic 3D shapes ------------------------------------------------------------------------------------------- */
UX_EXPORT void uxraylib_draw_line_3d(double sx, double sy, double sz, double ex, double ey, double ez, unsigned int color)
{
    DrawLine3D(V3((float)sx, (float)sy, (float)sz), V3((float)ex, (float)ey, (float)ez), uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_point_3d(double x, double y, double z, unsigned int color)
{
    DrawPoint3D(V3((float)x, (float)y, (float)z), uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_circle_3d(double cx, double cy, double cz, double radius, double ax, double ay, double az,
                                       double angleDegrees, unsigned int color)
{
    DrawCircle3D(V3((float)cx, (float)cy, (float)cz), (float)radius, V3((float)ax, (float)ay, (float)az),
                 (float)angleDegrees, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_triangle_3d(double x1, double y1, double z1, double x2, double y2, double z2,
                                         double x3, double y3, double z3, unsigned int color)
{
    DrawTriangle3D(V3((float)x1, (float)y1, (float)z1), V3((float)x2, (float)y2, (float)z2),
                   V3((float)x3, (float)y3, (float)z3), uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_cube(double x, double y, double z, double width, double height, double length, unsigned int color)
{
    DrawCube(V3((float)x, (float)y, (float)z), (float)width, (float)height, (float)length, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_cube_wires(double x, double y, double z, double width, double height, double length, unsigned int color)
{
    DrawCubeWires(V3((float)x, (float)y, (float)z), (float)width, (float)height, (float)length, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_sphere(double x, double y, double z, double radius, unsigned int color)
{
    DrawSphere(V3((float)x, (float)y, (float)z), (float)radius, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_sphere_ex(double x, double y, double z, double radius, int rings, int slices, unsigned int color)
{
    DrawSphereEx(V3((float)x, (float)y, (float)z), (float)radius, rings, slices, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_sphere_wires(double x, double y, double z, double radius, int rings, int slices, unsigned int color)
{
    DrawSphereWires(V3((float)x, (float)y, (float)z), (float)radius, rings, slices, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_cylinder(double x, double y, double z, double radiusTop, double radiusBottom, double height,
                                      int slices, unsigned int color)
{
    DrawCylinder(V3((float)x, (float)y, (float)z), (float)radiusTop, (float)radiusBottom, (float)height, slices, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_cylinder_wires(double x, double y, double z, double radiusTop, double radiusBottom, double height,
                                            int slices, unsigned int color)
{
    DrawCylinderWires(V3((float)x, (float)y, (float)z), (float)radiusTop, (float)radiusBottom, (float)height, slices, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_cylinder_ex(double sx, double sy, double sz, double ex, double ey, double ez,
                                         double startRadius, double endRadius, int sides, unsigned int color)
{
    DrawCylinderEx(V3((float)sx, (float)sy, (float)sz), V3((float)ex, (float)ey, (float)ez), (float)startRadius, (float)endRadius,
                   sides, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_cylinder_wires_ex(double sx, double sy, double sz, double ex, double ey, double ez,
                                               double startRadius, double endRadius, int sides, unsigned int color)
{
    DrawCylinderWiresEx(V3((float)sx, (float)sy, (float)sz), V3((float)ex, (float)ey, (float)ez), (float)startRadius, (float)endRadius,
                        sides, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_capsule(double sx, double sy, double sz, double ex, double ey, double ez, double radius,
                                     int slices, int rings, unsigned int color)
{
    DrawCapsule(V3((float)sx, (float)sy, (float)sz), V3((float)ex, (float)ey, (float)ez), (float)radius, slices, rings, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_capsule_wires(double sx, double sy, double sz, double ex, double ey, double ez, double radius,
                                           int slices, int rings, unsigned int color)
{
    DrawCapsuleWires(V3((float)sx, (float)sy, (float)sz), V3((float)ex, (float)ey, (float)ez), (float)radius, slices, rings, uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_plane(double cx, double cy, double cz, double sizeX, double sizeZ, unsigned int color)
{
    DrawPlane(V3((float)cx, (float)cy, (float)cz), V2((float)sizeX, (float)sizeZ), uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_ray_slots(int posSlot, int dirSlot, unsigned int color)
{
    DrawRay(uxSlotRay(posSlot, dirSlot), uxColorFromRGBA(color));
}
UX_EXPORT void uxraylib_draw_grid(int slices, double spacing) { DrawGrid(slices, (float)spacing); }
UX_EXPORT void uxraylib_draw_bounding_box_slots(int minSlot, int maxSlot, unsigned int color)
{
    DrawBoundingBox(uxSlotBox(minSlot, maxSlot), uxColorFromRGBA(color));
}

/* ---- meshes ---------------------------------------------------------------------------------------------------- */
UX_EXPORT int uxraylib_mesh_gen_poly(int sides, double radius) { return uxMeshStore(GenMeshPoly(sides, (float)radius)); }
UX_EXPORT int uxraylib_mesh_gen_plane(double width, double length, int resX, int resZ) { return uxMeshStore(GenMeshPlane((float)width, (float)length, resX, resZ)); }
UX_EXPORT int uxraylib_mesh_gen_cube(double width, double height, double length) { return uxMeshStore(GenMeshCube((float)width, (float)height, (float)length)); }
UX_EXPORT int uxraylib_mesh_gen_sphere(double radius, int rings, int slices) { return uxMeshStore(GenMeshSphere((float)radius, rings, slices)); }
UX_EXPORT int uxraylib_mesh_gen_hemisphere(double radius, int rings, int slices) { return uxMeshStore(GenMeshHemiSphere((float)radius, rings, slices)); }
UX_EXPORT int uxraylib_mesh_gen_cylinder(double radius, double height, int slices) { return uxMeshStore(GenMeshCylinder((float)radius, (float)height, slices)); }
UX_EXPORT int uxraylib_mesh_gen_cone(double radius, double height, int slices) { return uxMeshStore(GenMeshCone((float)radius, (float)height, slices)); }
UX_EXPORT int uxraylib_mesh_gen_torus(double radius, double size, int radSeg, int sides) { return uxMeshStore(GenMeshTorus((float)radius, (float)size, radSeg, sides)); }
UX_EXPORT int uxraylib_mesh_gen_knot(double radius, double size, int radSeg, int sides) { return uxMeshStore(GenMeshKnot((float)radius, (float)size, radSeg, sides)); }
UX_EXPORT int uxraylib_mesh_gen_heightmap(int image, double sizeX, double sizeY, double sizeZ)
{
    if (!uxImageOk(image)) return 0;
    return uxMeshStore(GenMeshHeightmap(uxImages[image], V3((float)sizeX, (float)sizeY, (float)sizeZ)));
}
UX_EXPORT int uxraylib_mesh_gen_cubicmap(int image, double cubeX, double cubeY, double cubeZ)
{
    if (!uxImageOk(image)) return 0;
    return uxMeshStore(GenMeshCubicmap(uxImages[image], V3((float)cubeX, (float)cubeY, (float)cubeZ)));
}
UX_EXPORT int uxraylib_mesh_valid(int mesh) { return uxMeshOk(mesh) ? 1 : 0; }
UX_EXPORT void uxraylib_mesh_unload(int mesh)
{
    if (!uxMeshOk(mesh)) return;
    UnloadMesh(uxMeshes[mesh]);
    uxMeshUsed[mesh] = 0;
}
UX_EXPORT int uxraylib_mesh_vertex_count(int mesh) { return uxMeshOk(mesh) ? uxMeshes[mesh].vertexCount : 0; }
UX_EXPORT int uxraylib_mesh_triangle_count(int mesh) { return uxMeshOk(mesh) ? uxMeshes[mesh].triangleCount : 0; }
/* component 0=x 1=y 2=z of vertex `index` (0 when out of range) */
UX_EXPORT double uxraylib_mesh_vertex(int mesh, int index, int component)
{
    if (!uxMeshOk(mesh) || index < 0 || index >= uxMeshes[mesh].vertexCount || component < 0 || component > 2) return 0.0;
    return (double)uxMeshes[mesh].vertices[index * 3 + component];
}
/* bounding box: register 0 = min, register 1 = max */
UX_EXPORT void uxraylib_mesh_bounding_box(int mesh)
{
    if (!uxMeshOk(mesh)) { uxSetV3(0, Vector3Zero()); uxSetV3(1, Vector3Zero()); return; }
    BoundingBox box = GetMeshBoundingBox(uxMeshes[mesh]);
    uxSetV3(0, box.min);
    uxSetV3(1, box.max);
}
UX_EXPORT void uxraylib_mesh_gen_tangents(int mesh) { if (uxMeshOk(mesh)) GenMeshTangents(&uxMeshes[mesh]); }
UX_EXPORT int uxraylib_mesh_export(int mesh, const char *path) { return uxMeshOk(mesh) ? (ExportMesh(uxMeshes[mesh], path) ? 1 : 0) : 0; }
UX_EXPORT int uxraylib_mesh_export_as_code(int mesh, const char *path) { return uxMeshOk(mesh) ? (ExportMeshAsCode(uxMeshes[mesh], path) ? 1 : 0) : 0; }
UX_EXPORT int uxraylib_ray_collision_mesh_slots(int posSlot, int dirSlot, int mesh, int transformMatrix)
{
    if (!uxMeshOk(mesh)) { uxRayCol.hit = false; return 0; }
    uxRayCol = GetRayCollisionMesh(uxSlotRay(posSlot, dirSlot), uxMeshes[mesh], uxMatrixGet(transformMatrix));
    return uxRayCol.hit ? 1 : 0;
}

/* ---- materials ------------------------------------------------------------------------------------------------- */
UX_EXPORT int uxraylib_material_load_default(void) { return uxMaterialStore(LoadMaterialDefault()); }
UX_EXPORT int uxraylib_material_valid(int material) { return uxMaterialOk(material) ? (IsMaterialValid(uxMaterials[material]) ? 1 : 0) : 0; }
UX_EXPORT void uxraylib_material_unload(int material)
{
    if (!uxMaterialOk(material)) return;
    UnloadMaterial(uxMaterials[material]);
    uxMaterialUsed[material] = 0;
}
/* mapType: 0 albedo/diffuse, 1 metalness, 2 normal, 3 roughness, 4 occlusion, 5 emission, 6 height, 7 cubemap, ... (raylib MATERIAL_MAP_*) */
UX_EXPORT void uxraylib_material_set_color(int material, int mapType, unsigned int color)
{
    if (!uxMaterialOk(material) || mapType < 0 || mapType >= 12) return;
    uxMaterials[material].maps[mapType].color = uxColorFromRGBA(color);
}
UX_EXPORT unsigned int uxraylib_material_get_color(int material, int mapType)
{
    if (!uxMaterialOk(material) || mapType < 0 || mapType >= 12) return 0;
    Color c = uxMaterials[material].maps[mapType].color;
    return uxraylib_color_rgba(c.r, c.g, c.b, c.a);
}
UX_EXPORT void uxraylib_material_set_texture(int material, int mapType, int texture)
{
    if (!uxMaterialOk(material) || mapType < 0 || mapType >= 12) return;
    if (texture <= 0 || texture >= UX_MAX_TEXTURES || !uxTextureUsed[texture]) return;
    SetMaterialTexture(&uxMaterials[material], mapType, uxTextures[texture]);
}

/* ---- models ---------------------------------------------------------------------------------------------------- */
UX_EXPORT int uxraylib_model_load(const char *path) { return uxModelStore(LoadModel(path)); }
UX_EXPORT int uxraylib_model_load_from_mesh(int mesh)
{
    if (!uxMeshOk(mesh)) return 0;
    Model model = LoadModelFromMesh(uxMeshes[mesh]);
    uxMeshUsed[mesh] = 0; /* the model owns the mesh now */
    return uxModelStore(model);
}
UX_EXPORT int uxraylib_model_valid(int model) { return uxModelOk(model) ? (IsModelValid(uxModels[model]) ? 1 : 0) : 0; }
UX_EXPORT void uxraylib_model_unload(int model)
{
    if (!uxModelOk(model)) return;
    UnloadModel(uxModels[model]);
    uxModelUsed[model] = 0;
}
UX_EXPORT int uxraylib_model_mesh_count(int model) { return uxModelOk(model) ? uxModels[model].meshCount : 0; }
UX_EXPORT int uxraylib_model_material_count(int model) { return uxModelOk(model) ? uxModels[model].materialCount : 0; }
UX_EXPORT int uxraylib_model_bone_count(int model) { return uxModelOk(model) ? uxModels[model].boneCount : 0; }
UX_EXPORT int uxraylib_model_mesh_vertex_count(int model, int meshIndex)
{
    if (!uxModelOk(model) || meshIndex < 0 || meshIndex >= uxModels[model].meshCount) return 0;
    return uxModels[model].meshes[meshIndex].vertexCount;
}
UX_EXPORT int uxraylib_model_mesh_triangle_count(int model, int meshIndex)
{
    if (!uxModelOk(model) || meshIndex < 0 || meshIndex >= uxModels[model].meshCount) return 0;
    return uxModels[model].meshes[meshIndex].triangleCount;
}
/* bounding box of the model (raylib GetModelBoundingBox): register 0 = min, register 1 = max */
UX_EXPORT void uxraylib_model_bounding_box(int model)
{
    if (!uxModelOk(model)) { uxSetV3(0, Vector3Zero()); uxSetV3(1, Vector3Zero()); return; }
    BoundingBox box = GetModelBoundingBox(uxModels[model]);
    uxSetV3(0, box.min);
    uxSetV3(1, box.max);
}
UX_EXPORT void uxraylib_model_set_transform(int model, int matrix)
{
    if (uxModelOk(model)) uxModels[model].transform = uxMatrixGet(matrix);
}
UX_EXPORT int uxraylib_model_get_transform(int model)
{
    if (!uxModelOk(model)) return 0;
    return uxMatrixPut(uxModels[model].transform);
}
UX_EXPORT void uxraylib_model_set_mesh_material(int model, int meshIndex, int materialIndex)
{
    if (!uxModelOk(model) || meshIndex < 0 || meshIndex >= uxModels[model].meshCount) return;
    if (materialIndex < 0 || materialIndex >= uxModels[model].materialCount) return;
    SetModelMeshMaterial(&uxModels[model], meshIndex, materialIndex);
}
/* material `materialIndex` OF THE MODEL: colour / texture of a material map (raylib MATERIAL_MAP_*) */
UX_EXPORT void uxraylib_model_material_set_color(int model, int materialIndex, int mapType, unsigned int color)
{
    if (!uxModelOk(model) || materialIndex < 0 || materialIndex >= uxModels[model].materialCount || mapType < 0 || mapType >= 12) return;
    uxModels[model].materials[materialIndex].maps[mapType].color = uxColorFromRGBA(color);
}
UX_EXPORT void uxraylib_model_material_set_texture(int model, int materialIndex, int mapType, int texture)
{
    if (!uxModelOk(model) || materialIndex < 0 || materialIndex >= uxModels[model].materialCount || mapType < 0 || mapType >= 12) return;
    if (texture <= 0 || texture >= UX_MAX_TEXTURES || !uxTextureUsed[texture]) return;
    SetMaterialTexture(&uxModels[model].materials[materialIndex], mapType, uxTextures[texture]);
}
UX_EXPORT void uxraylib_draw_model(int model, double x, double y, double z, double scale, unsigned int tint)
{
    if (uxModelOk(model)) DrawModel(uxModels[model], V3((float)x, (float)y, (float)z), (float)scale, uxColorFromRGBA(tint));
}
UX_EXPORT void uxraylib_draw_model_wires(int model, double x, double y, double z, double scale, unsigned int tint)
{
    if (uxModelOk(model)) DrawModelWires(uxModels[model], V3((float)x, (float)y, (float)z), (float)scale, uxColorFromRGBA(tint));
}
UX_EXPORT void uxraylib_draw_model_points(int model, double x, double y, double z, double scale, unsigned int tint)
{
    if (uxModelOk(model)) DrawModelPoints(uxModels[model], V3((float)x, (float)y, (float)z), (float)scale, uxColorFromRGBA(tint));
}
/* position / rotation axis / scale come from vector slots */
UX_EXPORT void uxraylib_draw_model_ex_slots(int model, int posSlot, int axisSlot, double angleDegrees, int scaleSlot, unsigned int tint)
{
    if (uxModelOk(model)) DrawModelEx(uxModels[model], uxSlotV3(posSlot), uxSlotV3(axisSlot), (float)angleDegrees, uxSlotV3(scaleSlot), uxColorFromRGBA(tint));
}
UX_EXPORT void uxraylib_draw_model_wires_ex_slots(int model, int posSlot, int axisSlot, double angleDegrees, int scaleSlot, unsigned int tint)
{
    if (uxModelOk(model)) DrawModelWiresEx(uxModels[model], uxSlotV3(posSlot), uxSlotV3(axisSlot), (float)angleDegrees, uxSlotV3(scaleSlot), uxColorFromRGBA(tint));
}
UX_EXPORT void uxraylib_draw_mesh(int mesh, int material, int transformMatrix)
{
    if (!uxMeshOk(mesh) || !uxMaterialOk(material)) return;
    DrawMesh(uxMeshes[mesh], uxMaterials[material], uxMatrixGet(transformMatrix));
}
UX_EXPORT void uxraylib_draw_billboard(int camera, int texture, double x, double y, double z, double size, unsigned int tint)
{
    if (texture <= 0 || texture >= UX_MAX_TEXTURES || !uxTextureUsed[texture]) return;
    DrawBillboard(uxCameraGet(camera), uxTextures[texture], V3((float)x, (float)y, (float)z), (float)size, uxColorFromRGBA(tint));
}

/* ---- model animations -------------------------------------------------------------------------------------------- */
/* returns an animation SET handle (0 = none); uxraylib_anim_count tells how many animations it holds */
UX_EXPORT int uxraylib_anim_load(const char *path)
{
    int count = 0;
    ModelAnimation *set = LoadModelAnimations(path, &count);
    if (set == NULL || count <= 0) return 0;
    for (int i = 1; i < UX_MAX_ANIMSETS; ++i) {
        if (!uxAnimUsed[i]) { uxAnimSets[i] = set; uxAnimCounts[i] = count; uxAnimUsed[i] = 1; return i; }
    }
    UnloadModelAnimations(set, count);
    return 0;
}
UX_EXPORT int uxraylib_anim_count(int set) { return uxAnimOk(set) ? uxAnimCounts[set] : 0; }
UX_EXPORT int uxraylib_anim_frame_count(int set, int index)
{
    if (!uxAnimOk(set) || index < 0 || index >= uxAnimCounts[set]) return 0;
    return uxAnimSets[set][index].frameCount;
}
UX_EXPORT int uxraylib_anim_bone_count(int set, int index)
{
    if (!uxAnimOk(set) || index < 0 || index >= uxAnimCounts[set]) return 0;
    return uxAnimSets[set][index].boneCount;
}
UX_EXPORT int uxraylib_anim_compatible(int model, int set, int index)
{
    if (!uxModelOk(model) || !uxAnimOk(set) || index < 0 || index >= uxAnimCounts[set]) return 0;
    return IsModelAnimationValid(uxModels[model], uxAnimSets[set][index]) ? 1 : 0;
}
UX_EXPORT void uxraylib_anim_update(int model, int set, int index, int frame)
{
    if (!uxModelOk(model) || !uxAnimOk(set) || index < 0 || index >= uxAnimCounts[set]) return;
    UpdateModelAnimation(uxModels[model], uxAnimSets[set][index], frame);
}
UX_EXPORT void uxraylib_anim_update_bones(int model, int set, int index, int frame)
{
    if (!uxModelOk(model) || !uxAnimOk(set) || index < 0 || index >= uxAnimCounts[set]) return;
    UpdateModelAnimationBones(uxModels[model], uxAnimSets[set][index], frame);
}
UX_EXPORT void uxraylib_anim_unload(int set)
{
    if (!uxAnimOk(set)) return;
    UnloadModelAnimations(uxAnimSets[set], uxAnimCounts[set]);
    uxAnimSets[set] = NULL;
    uxAnimCounts[set] = 0;
    uxAnimUsed[set] = 0;
}

/* ---- screen read-back (lets a program verify what it drew) -------------------------------------------------------- */
/* Image of the current framebuffer; returns an IMAGE handle (uxraylib_image_* functions), 0 on failure. Call it after the
   drawing you want to inspect and before EndDrawing (EndMode3D has already flushed the 3D batch). */
UX_EXPORT int uxraylib_image_from_screen(void) { return uxImageStore(LoadImageFromScreen()); }
