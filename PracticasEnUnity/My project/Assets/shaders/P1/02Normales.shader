Shader "Unlit/02Normales"
{
    Properties { }
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
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VsOut {
                float4 pos : SV_POSITION ;
                float4 color : COLOR;
            };

            VsOut vsMain ( VsIn v )
            {
                VsOut o ;
                o.pos = TransformObjectToHClip(v.vertex.xyz);
                // como rgb va de (0,1) los negativos no salen porque salen por debajo y se quedan en negro, y si fueran por encima de 1 se quedarian en blanco.
                // (xyz, 1) == (x, y, z, 1)
                o.color = float4(v.normal.xyz, 1.0f);
                return o ;
            }

            float4 psMain (VsOut i) : SV_TARGET
            {
                return abs(i.color); // con abs es todo de colores porque los negativos les quita signo.
            }

            ENDHLSL 
        }
    }
    Fallback Off
}
