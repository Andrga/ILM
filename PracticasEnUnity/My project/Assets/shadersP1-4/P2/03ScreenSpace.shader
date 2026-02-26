Shader "Unlit/03ScreenSpace"
{
    Properties
    {
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
            "RenderPipeline" = "UniversalPipeline"
        }
        Pass
        {
            Tags {"LightMode" = "UniversalForward"}

            HLSLPROGRAM
            # include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            # pragma vertex vsMain
            # pragma fragment psMain

            struct VsIn {
                float4 vertex : POSITION ;
            };
            struct VsOut {
                float4 pos : SV_POSITION;
                float4 pos2 : TEXCOORD0;
                float4 ss : TEXCOORD1; // con esta si se ve, distinta semantica
            };

            VsOut vsMain ( VsIn v )
            {
                VsOut o ;
                o.pos = TransformObjectToHClip(v.vertex.xyz);
                o.pos2 = TransformObjectToHClip(v.vertex.xyz);
                o.ss = ComputeScreenPos(o.pos);
                return o ;
            }

            // float4 psMain (VsOut i) : SV_TARGET
            // {
            //     float4 ss = ComputeScreenPos(i.pos2);
            //     return float4((ss.xy / ss.w), 0.0f, 1.0f);
            // }
            
            float4 psMain (VsOut i) : SV_TARGET
            {
                return float4((i.ss.xy / i.ss.w), 0.0f, 1.0f);
            }

            ENDHLSL 
        }
    }
    Fallback Off
}
