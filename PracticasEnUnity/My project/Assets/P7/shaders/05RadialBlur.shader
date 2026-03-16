Shader "Custom/05RadialBlur"
{
    Properties
    {
        _CenterX("Center (X)", float) = 0.5
        _CenterY("Center (Y)", float) = 0.5
        _Scale("Scale", float) = 10
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
            float _CenterX;
            float _CenterY;
            float _Scale;
            CBUFFER_END

            SAMPLER ( sampler_BlitTexture );

            half4 psMain (Varyings input) : SV_TARGET {
                // sacar coordenadas de pantalla.
                float2 uv = input.texcoord;
                float2 screenXY = uv * _ScreenParams.xy; // pixel k estamos pintando

                float4 color = float4(0.0f, 0.0f, 0.0f, 0.0f);

                for (int i = 0; i < 10; i++){
                    float2 direction = float2(screenXY.x-_CenterX, screenXY.y-_CenterY) * (_Scale * i);

                    float2 covertedUVs = float2((screenXY.x + direction.x), (screenXY.y + direction.y)) / _ScreenParams.xy;


                    color += SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture , covertedUVs) * 1-(1.0f/(i+1));

                    //color += float4(0.0f, 0.0f, 0.0f, (1/(i+1)));
                }

                return color;
            }
            ENDHLSL
        }
    }
    FallBack "Diffuse"
}
