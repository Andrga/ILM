Shader "Unlit/04Textura"
{
    Properties 
    { 
        _MainTex ("Base (RGB)", 2D) = "" {}
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
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            struct VsOut {
                float4 pos : SV_POSITION ;
                float2 uv : TEXCOORD0;
            };
            
            CBUFFER_START(UnityPerMaterial)
            sampler2D _MainTex;
            CBUFFER_END

            VsOut vsMain ( VsIn v )
            {
                VsOut o ;
                o.pos = TransformObjectToHClip(v.vertex.xyz);
                o.uv = v.uv; // se lo pasa sin alterar, pasa las uvs como tal
                return o;
            }
            
            float4 psMain (VsOut i) : SV_TARGET
            {
                return tex2D(_MainTex, i.uv);
            }

            ENDHLSL 
        }
    }
    Fallback Off
}
