Shader "Hidden/SimpleBlur"
{
    Properties
    {
       _factor("Factor",Range(0.0, 1.0)) = 0.5
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

                float sx = _ScreenParams.x;
                float sy = _ScreenParams.y;

                float4 k11 = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture , input.texcoord + float2(-1.0/sx, -1.0/sy));
                float4 k12 = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture , input.texcoord + float2(0.0/sx, -1.0/sy));
                float4 k13 = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture , input.texcoord + float2(1.0/sx, -1.0/sy));
   
                float4 k21 = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture , input.texcoord + float2(-1.0/sx, 0.0/sy));
                float4 k22 = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture , input.texcoord + float2(0.0/sx, 0.0/sy));
                float4 k23 = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture , input.texcoord + float2(1.0/sx, 0.0/sy));

                float4 k31 = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture , input.texcoord + float2(-1.0/sx, 1.0/sy));
                float4 k32 = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture , input.texcoord + float2(0.0/sx, 1.0/sy));
                float4 k33 = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture , input.texcoord + float2(1.0/sx, 1.0/sy));

                float4 kernel = (
                    1*k11 + 2*k12 + 1*k13 + 
                    2*k21 + 4*k22 + 2*k23 + 
                    1*k31 + 2*k32 + 1*k33) / 16;
                //return kernel;
                return lerp(color, kernel, _factor);
            }
            ENDHLSL
        }
    }
    FallBack "Diffuse"
  }