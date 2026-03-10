Shader "Unlit/02Reflection"
{
    Properties
    {
        _Horizontal("Horizontal flip", Range(0.0, 1.0)) = 0.0
        _Vertical("Vertical flip", Range(0.0, 1.0)) = 0.0
    }
    SubShader
    {
       
        Tags {
			"RenderType" = "Opaque"
			"RenderPipeline" = "UniversalPipeline"
		}
        Pass
        {
            Name "Reflexion"
            Cull Off 
            ZWrite Off
            ZTest Always 
            //Blend SrcAlpha OneMinusSrcAlpha // hace que pinte transparente

            HLSLPROGRAM
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"

            #pragma vertex Vert
            #pragma fragment psMain 

			CBUFFER_START(UnityPerMaterial)
			float _Horizontal;
			float _Vertical;
			CBUFFER_END

			//TEXTURE2D_X ( _BlitTexture );
            SAMPLER ( sampler_BlitTexture );

            half4 psMain (Varyings input) : SV_TARGET {
                float2 uv = input.texcoord;
                if (input.texcoord.x < _Horizontal){
                    uv.x = 1-uv.x;
                }
                
                if(input.texcoord.y < _Vertical){
                    uv.y = 1-uv.y;
                }

                return SAMPLE_TEXTURE2D_X ( _BlitTexture, sampler_BlitTexture, uv);
            }
            ENDHLSL
        }
    }
    FallBack "Diffuse"
}
