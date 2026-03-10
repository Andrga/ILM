Shader "Custom/01MarcaAgua"
{
    Properties
    {
		_MainTex ("Base (RGB)", 2D) = "" {}
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
            
			TEXTURE2D_X(_MainTex);
            SAMPLER(sampler_MainTex);

            half4 psMain (Varyings input) : SV_TARGET {
                return SAMPLE_TEXTURE2D_X(_MainTex, sampler_MainTex , input.texcoord);
            }
            ENDHLSL
        }
    }
    FallBack "Diffuse"
}
