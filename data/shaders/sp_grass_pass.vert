uniform vec3 wind_direction;

layout(location = 0) in vec3 i_position;

#if defined(Converts_10bit_Vector)
layout(location = 1) in int i_normal_pked;
#else
layout(location = 1) in vec4 i_normal;
#endif

layout(location = 2) in vec4 i_color;
layout(location = 3) in vec2 i_uv;
layout(location = 8) in vec3 i_origin;

#if defined(Converts_10bit_Vector)
layout(location = 9) in int i_rotation_pked;
#else
layout(location = 9) in vec4 i_rotation;
#endif

layout(location = 10) in vec4 i_scale;

#if defined(Converts_10bit_Vector)
layout(location = 11) in int i_misc_data_pked;
#else
layout(location = 11) in vec4 i_misc_data;
#endif

#if defined(Use_Bindless_Texture)
layout(location = 13) in uvec4 i_bindless_texture_0;
layout(location = 14) in uvec4 i_bindless_texture_1;
layout(location = 15) in uvec4 i_bindless_texture_2;
#elif defined(Use_Array_Texture)
layout(location = 13) in uvec4 i_array_texture_0;
layout(location = 14) in uvec2 i_array_texture_1;
#endif

#stk_include "utils/get_world_location.vert"

out vec3 normal;
out vec2 uv;
flat out float hue_change;

#if defined(Use_Bindless_Texture)
flat out sampler2D tex_layer_0;
flat out sampler2D tex_layer_1;
flat out sampler2D tex_layer_2;
flat out sampler2D tex_layer_3;
flat out sampler2D tex_layer_4;
flat out sampler2D tex_layer_5;
#elif defined(Use_Array_Texture)
flat out float array_0;
flat out float array_1;
flat out float array_2;
flat out float array_3;
flat out float array_4;
flat out float array_5;
#endif

void main()
{

#if defined(Converts_10bit_Vector)
    vec4 i_normal = convert10BitVector(i_normal_pked);
    vec4 i_rotation = convert10BitVector(i_rotation_pked);
    vec4 i_misc_data = convert10BitVector(i_misc_data_pked);
#endif

#if defined(Use_Bindless_Texture)
    tex_layer_0 = sampler2D(i_bindless_texture_0.xy);
    tex_layer_1 = sampler2D(i_bindless_texture_0.zw);
    tex_layer_2 = sampler2D(i_bindless_texture_1.xy);
    tex_layer_3 = sampler2D(i_bindless_texture_1.zw);
    tex_layer_4 = sampler2D(i_bindless_texture_2.xy);
    tex_layer_5 = sampler2D(i_bindless_texture_2.zw);
#elif defined(Use_Array_Texture)
    array_0 = float(i_array_texture_0.x);
    array_1 = float(i_array_texture_0.y);
    array_2 = float(i_array_texture_0.z);
    array_3 = float(i_array_texture_0.w);
    array_4 = float(i_array_texture_1.x);
    array_5 = float(i_array_texture_1.y);
#endif

    vec3 test = sin(wind_direction * (i_position.y * 0.1));
    test += cos(wind_direction) * 0.7;

    vec4 quaternion = normalize(vec4(i_rotation.xyz, i_scale.w));
    vec4 world_position = getWorldPosition(i_origin + test * i_color.r,
        quaternion, i_scale.xyz, i_position);
    vec3 world_normal = rotateVector(quaternion, i_normal.xyz);

    normal = (u_view_matrix * vec4(world_normal, 0.0)).xyz;
    uv = i_uv;
    hue_change = i_misc_data.z;
    gl_Position = u_projection_view_matrix * world_position;
}