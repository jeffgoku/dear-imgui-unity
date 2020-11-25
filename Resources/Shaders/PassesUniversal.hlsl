#ifndef DEARIMGUI_UNIVERSAL_INCLUDED
#define DEARIMGUI_UNIVERSAL_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#ifndef UNITY_COLORSPACE_GAMMA
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#endif
#include "Assets/dear-IMGUI/Resources/Shaders/Common.hlsl"

TEXTURE2D(_Tex);
SAMPLER(sampler_Tex);


#ifdef SHADER_API_METAL
half4 unpack_color(half4 c)
#else
half4 unpack_color(uint c)
#endif
{
#ifdef SHADER_API_METAL
    half4 color = c/255;
#else
    half4 color = half4(
        (c      ) & 0xff,
        (c >>  8) & 0xff,
        (c >> 16) & 0xff,
        (c >> 24) & 0xff
    ) / 255;
#endif
#ifndef UNITY_COLORSPACE_GAMMA
    color.rgb = FastSRGBToLinear(color.rgb);
#endif
    return color;
}

Varyings ImGuiPassVertex(ImVert input)
{
    Varyings output  = (Varyings)0;
    output.vertex    = TransformWorldToHClip(TransformObjectToWorld(float3(input.vertex, 0.0)));
    output.uv        = float2(input.uv.x, 1 - input.uv.y);
    output.color     = unpack_color(input.color);
    return output;
}

half4 ImGuiPassFrag(Varyings input) : SV_Target
{
    return input.color * SAMPLE_TEXTURE2D(_Tex, sampler_Tex, input.uv);
    //return half4(1,1,1,1);
}

#endif
