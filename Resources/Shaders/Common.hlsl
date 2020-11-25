#ifndef DEARIMGUI_COMMON_INCLUDED
#define DEARIMGUI_COMMON_INCLUDED

struct ImVert   // same layout as ImDrawVert
{
    float2 vertex   : POSITION;
    float2 uv       : TEXCOORD0;
#ifdef SHADER_API_METAL
    half4  color    : TEXCOORD1; // gets reordered when using COLOR semantics
#else
    uint color : TEXCOORD1;
#endif
};

struct Varyings
{
    float4 vertex   : SV_POSITION;
    float2 uv       : TEXCOORD0;
    half4  color    : COLOR;
};

#endif
