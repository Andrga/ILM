Shader "Unlit/04AplhaClipping"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "" {}
        _CutThresold("Cutoff thresold", float) = 0.0
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry+10"
            "RenderPipeline" = "UniversalPipeline"
        }
        Pass
        {
            Tags {"LightMode" = "UniversalForward"}
            Cull Off

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
                float4 localCoords : POSITION1;
                float2 uv : TEXCOORD0;
            };
            
            CBUFFER_START(UnityPerMaterial)
            sampler2D _MainTex;
            float _CutThresold;
            CBUFFER_END

            VsOut vsMain ( VsIn v )
            {
                VsOut o ;
                o.pos = TransformObjectToHClip(v.vertex.xyz);
                o.uv = v.uv; // se lo pasa sin alterar, pasa las uvs como tal
                o.localCoords = v.vertex;
                return o;
            }
            
            float4 psMain (VsOut i) : SV_TARGET
            {
                [branch]
                if(i.localCoords.y > _CutThresold){
                    discard;
                }
                return tex2D(_MainTex, i.uv);
            }

            ENDHLSL 
        }
    }
    Fallback Off
}