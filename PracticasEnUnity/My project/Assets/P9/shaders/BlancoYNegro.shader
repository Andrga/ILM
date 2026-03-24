Shader "Hidden/BlancoYNegro"
{
    Properties
    {
        _Intensity("Intensidad Blanco y Negro",Range(0.0, 1.0)) = 0.5
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
			float _Intensity;
			CBUFFER_END

            #pragma vertex Vert
            #pragma fragment psMain  
            
			SAMPLER (sampler_BlitTexture);

            half4 psMain (Varyings input) : SV_TARGET {
                float4 rgb = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture , input.texcoord);
                float intens = 0.299f * rgb.x + 0.587f * rgb.y + 0.114f * rgb.z;
                float4 bn = float4(intens, intens, intens, 1.0f);

                return lerp(rgb, bn, _Intensity);
                //return float4(_Intensity, _Intensity, _Intensity, 1.0)
            }
            ENDHLSL
        }
    }
    FallBack "Diffuse"
}
