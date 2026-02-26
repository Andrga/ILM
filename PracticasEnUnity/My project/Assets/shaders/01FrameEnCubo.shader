Shader "Unlit/01FrameEnCubo"
{
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Transparent-1"
            "RenderPipeline" = "UniversalPipeline"
        }
        Pass
        {

            HLSLPROGRAM
            # include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            # include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareOpaqueTexture.hlsl"

            # pragma vertex vsMain
            # pragma fragment psMain
            
            struct VsIn {
                float4 vertex : POSITION;

                float2 uv : TEXCOORD0;
            };

            struct VsOut {
                float4 pos : SV_POSITION;
                
                float2 uv : TEXCOORD0;
            };

            VsOut vsMain ( VsIn v )
            {
                VsOut o ;
                o.pos = TransformObjectToHClip(v.vertex.xyz);

                o.uv = v.uv;
               
                return o;
            }

            float4 psMain (VsOut i) : SV_TARGET {

                return float4(SampleSceneColor(i.uv), 1.0);
            }

            ENDHLSL 
        }
    }
}
