Shader "Unlit/05Profundidad"
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
                float4 posCS : TEXCOORD0;
                float4 posSS : TEXCOORD1; // con esta si se ve, distinta semantica
            };

            VsOut vsMain ( VsIn v )
            {
                VsOut o ;
                o.pos = TransformObjectToHClip(v.vertex.xyz);
                o.posCS = TransformObjectToHClip(v.vertex.xyz);
                o.posSS = ComputeScreenPos(o.pos);
                o.posSS = float4((o.posSS.xy/o.posCS.w), 0.0f, 1.0f);
                return o ;
            }
            
            float4 psMain (VsOut i) : SV_TARGET
            {
                return i.posSS;
            }

            ENDHLSL 
        }
    }
    Fallback Off
}
