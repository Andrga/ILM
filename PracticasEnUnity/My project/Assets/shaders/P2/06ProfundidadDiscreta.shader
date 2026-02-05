Shader "Unlit/06ProfundidadDiscreta"
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
                float4 posZBuf : TEXCOORD0; // con esta si se ve, distinta semantica
            };

            VsOut vsMain ( VsIn v )
            {
                VsOut o ;
                o.pos = TransformObjectToHClip(v.vertex.xyz);
                o.posZBuf = ComputeScreenPos(o.pos);
                
                return o ;
            }
            
            float4 psMain (VsOut i) : SV_TARGET
            {
                return float4(
                    (int)((i.pos.z/i.pos.w) *10) /10.0f, 
                    (int)((i.pos.z/i.pos.w) *10) /10.0f, 
                    (int)((i.pos.z/i.pos.w) *10) /10.0f, 
                    1.0f);
            }

            ENDHLSL 
        }
    }
    Fallback Off
}
