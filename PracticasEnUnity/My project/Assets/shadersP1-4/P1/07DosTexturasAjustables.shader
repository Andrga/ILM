Shader "Unlit/07DosTexturasAjustables"
{
    Properties 
    { 
        _MainTex ("Base (RGB)", 2D) = "" {}
        _SecondaryTex ("Secondary (RGB)", 2D) = "" {}
        _BlendTex ("Alpha Blended (___A)", 2D) = "" {}
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
            sampler2D _SecondaryTex;
            sampler2D _BlendTex;
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
                float4 textura1 = tex2D(_MainTex, i.uv);
                float4 textura2 = tex2D(_SecondaryTex, i.uv);
                float alpha = tex2D(_BlendTex, i.uv).a;
                return ((textura1 + textura2)* alpha)/2;
            }

            ENDHLSL 
        }
    }
    Fallback Off
}
