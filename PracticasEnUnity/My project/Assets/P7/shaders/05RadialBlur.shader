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
            Blend SrcAlpha OneMinusSrcAlpha // hace que pinte transparente

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
                // multiplicamos por screenParams.xy para convertirlo a coordenadas de pantalla (en pixeles).
                float2 center = float2(_CenterX, _CenterY) * _ScreenParams.xy; // centro del blur.

                // calcular la direccion del blur, que va desde el pixel que estamos pintando hasta el centro del blur.
                float2 dir = center - screenXY; //direccion del blur.
                float  len = length(dir); // distancia entre el pixel que estamos pintando y el centro del blur.
                // normalizamos la direccion del blur y la escalamos por el valor de _Scale.
                float2 direction = (len > 0.0001) ? (dir / len) * _Scale : float2(0.0, 0.0); // si la distancia es muy pequeña, no hacemos nada para evitar divisiones por cero.

                float4 color = float4(0.0f, 0.0f, 0.0f, 0.0f);

                // Muestras desde el pixel actual, desplazandose hacia el centro
                for (int i = 0; i < 10; i++){
                    // Movemos el pixel que estamos pintando en la direccion del blur.
                    float2 samplePixel = screenXY + direction * (float(i) / 9.0);

                    //float2 covertedUVs = float2((screenXY.x + direction.x), (screenXY.y + direction.y)) / _ScreenParams.xy;
                    float2 covertedUVs    = samplePixel / _ScreenParams.xy; // convertir a UV para samplear.


                    // el 55 es la suma de los numeros del 1 al 10, para normalizar el resultado y que no se sature el color.
                    color += SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_BlitTexture , covertedUVs) * float(10 - i) / 55; 

                    //color += float4(0.0f, 0.0f, 0.0f, (1/(i+1)));
                }

                return color;
            }
            ENDHLSL
        }
    }
    FallBack "Diffuse"
}
