Shader "Unlit/03bVisibleAtras"
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
            name "Pasada1"
            ZTest Greater
            ZWrite Off
            Tags {"LightMode" = "UniversalForward"}

            HLSLPROGRAM
            # include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            # pragma vertex vsMain
            # pragma fragment psMain

            struct VsIn {
                float4 vertex : POSITION ;
                float3 normal : NORMAL;
            };
            struct VsOut {
                float4 pos : SV_POSITION ;
            };

            VsOut vsMain ( VsIn v )
            {
                VsOut o ;
                o.pos = TransformObjectToHClip(v.vertex.xyz);
                return o ;
            }

            float4 psMain (VsOut i) : SV_TARGET
            {
                return float4(1.0f, 0.0f, 0.0f, 1.0f);
            }

            ENDHLSL 
        }
        Pass
        {
            name "Pasada2"

            HLSLPROGRAM
            # include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            # pragma vertex vsMain
            # pragma fragment psMain

            struct VsIn {
                float4 vertex : POSITION ;
            };
            struct VsOut {
                float4 pos : SV_POSITION ;
            };

            VsOut vsMain ( VsIn v )
            {
                VsOut o ;
                o.pos = TransformObjectToHClip(v.vertex.xyz);
                return o ;
            }

            float4 psMain (VsOut i) : SV_TARGET
            {
                return float4(1.0f, 0.0f, 0.0f, 1.0f);
            }

            ENDHLSL 
        }
    }
}
