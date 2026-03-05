Shader "Unlit/02StencilMask"
{
    Properties
    {
        [IntRange] _StencilRef("Stencil Ref", Range(0, 255)) = 1
    }
    SubShader
    {
        Tags {
            "RenderType" = "Opaque"
            "Queue" = "Geometry-1"
            "RenderPipeline" = "UniversalPipeline"
        }
        Pass
        {
            Tags { "LightMode" = "UniversalForward" }
            Stencil {
                Ref[_StencilRef]
                Comp Always
                Pass Replace
            }
            ZWrite Off
        }

    }
}
