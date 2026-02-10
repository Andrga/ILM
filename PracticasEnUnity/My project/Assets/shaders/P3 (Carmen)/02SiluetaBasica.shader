Shader "Unlit/02SiluetaBasica"
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
            Name "DibujadoEstandar"
            Tags {"LightMode" = "UniversalForward"}

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
        Pass
        {
            Name "DibujadoTrasladado"
            Cull Front
            // Por defecto unity pinta solo las caras delanteras "cull back"
            // si queremos que el motor elimine las frontales en lugar de las traseras se pone "cull Front" debajo del nombe de la pasada
            // Si queremos que pinten caras delanteras y traseras "cull off"
            // Si queremos que no pinte un pixel "discard" en el pixel shader

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
                // multiplicarlo dentro es en el mundo de unity y multiplicarlo fuera es multiplicarlo en el espacio de pantalla
                o.pos = TransformObjectToHClip(v.vertex.xyz * 1.05f);
                return o ;
            }

            float4 psMain (VsOut i) : SV_TARGET
            {
                return float4(0.0f, 0.0f, 0.0f, 1.0f);
            }

            ENDHLSL 
        }
    }
    Fallback Off
}
