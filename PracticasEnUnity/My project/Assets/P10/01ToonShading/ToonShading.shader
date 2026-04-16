Shader "Hidden/ToonShading"
{
    Properties
    {
       _factor("Factor",Range(0, 10)) = 5
    }
    SubShader
    {
       
        Tags {
			"RenderType" = "Opaque"
			"RenderPipeline" = "UniversalPipeline"
		}
        LOD 100
        Pass
        {
            Cull Off 
            ZWrite Off
            ZTest Always 
            //Blend SrcAlpha OneMinusSrcAlpha // hace que pinte transparente

            HLSLPROGRAM
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"

			CBUFFER_START(UnityPerMaterial)
			float _factor;
			CBUFFER_END

            #pragma vertex Vert
            #pragma fragment psMain  
            
			SAMPLER (sampler_BlitTexture);

            half4 psMain (Varyings input) : SV_TARGET {
                float4 color = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture , input.texcoord);
                int4 colorint = color * _factor;
                color = colorint/_factor;
   
                return color;
            }
            ENDHLSL
        }
    }
    FallBack "Diffuse"
  }