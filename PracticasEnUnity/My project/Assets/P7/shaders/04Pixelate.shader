Shader "Custom/04Pixelate"
{
    Properties
    {
        [IntRange] _PixelSize("Tamaño de cada pixel", Range(0, 100)) = 1
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
            Name "Marca_de_agua"
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
            int _PixelSize;
            CBUFFER_END

            SAMPLER ( sampler_BlitTexture );

            half4 psMain (Varyings input) : SV_TARGET {
                // sacar coordenadas de pantalla.
                float2 uv = input.texcoord;
                float2 screenXY = uv * _ScreenParams.xy; // pixel k estamos pintando

                // halla teselas, centros, posiciones.
                int x = screenXY.x / _PixelSize;
                int y = screenXY.y / _PixelSize;
                float centX = x *_PixelSize + _PixelSize/2;
                float centY = y *_PixelSize + _PixelSize/2;

                float2 covertedUVs = float2(centX/_ScreenParams.x, centY/_ScreenParams.y);

                return SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture , covertedUVs);
            }
            ENDHLSL
        }
    }
    FallBack "Diffuse"
}
