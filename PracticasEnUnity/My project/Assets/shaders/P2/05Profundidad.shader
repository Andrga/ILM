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
                float4 posZBuf : TEXCOORD0; // con esta si se ve, distinta semantica
                float4 color : COLOR;
            };

            VsOut vsMain ( VsIn v )
            {
                VsOut o ;
                o.pos = TransformObjectToHClip(v.vertex.xyz);
                o.posZBuf = ComputeScreenPos(o.pos);
                o.color = float4((o.posZBuf.z/o.posZBuf.w),(o.posZBuf.z/o.posZBuf.w), (o.posZBuf.z/o.posZBuf.w), 1.0f);
                return o ;
            }
            
            float4 psMain (VsOut i) : SV_TARGET
            {
                return i.color;
            }

            ENDHLSL 
        }
    }
    Fallback Off
}
