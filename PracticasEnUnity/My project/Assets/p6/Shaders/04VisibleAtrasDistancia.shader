Shader "Unlit/04VisibleAtrasDistancia"
{
	Properties
	{
	_MainTex ("Base (RGB)", 2D) = "" {}
	_BackgroundColor("Background Color", Color) = (0.0, 0.0, 0.0)
	_Distance("Distancia maxima", Range(0.01, 1000)) = 2
	}
	SubShader
	{
		Tags {
			"RenderType" = "Transparent"
			"Queue" = "Transparent"
			"RenderPipeline" = "UniversalPipeline"
		}
		Pass
		{
			Tags { "LightMode" = "UniversalForward" }
			
			ZWrite Off
			ZTest Off
			Blend SrcAlpha OneMinusSrcAlpha  

			HLSLPROGRAM

			#pragma vertex vsMain
			#pragma fragment psMain
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"

			sampler2D _MainTex; 
			CBUFFER_START(UnityPerMaterial)
			float4 _MainTex_ST;
			float4 _BackgroundColor;
			float _Distance;
			CBUFFER_END

			struct VsIn {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct VsOut {
				float4 pos : SV_POSITION;
                float4 posSS : TEXCOORD0;
				float2 uv : TEXCOORD1;
			};

			VsOut vsMain(VsIn v) {
				VsOut o;
				o.pos = TransformObjectToHClip(v.vertex.xyz);
                o.posSS = ComputeScreenPos(o.pos);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			float4 psMain(VsOut i) : SV_Target {				
                float2 screenUV = i.posSS.xy / i.posSS.w;
				
				// deph texture del punto de la pantalla actual a renderizar
				float rawDepth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, sampler_CameraDepthTexture, screenUV);
				// distancia hasta la camara del fragmento ya renderizado
				float sceneDepth = LinearEyeDepth(rawDepth, _ZBufferParams);
				// distancia hasta la camara del fragmento actual
				float fragDepth = i.posSS.w;
				// distancia entre el punto ya renderizado y el que vamos a renderizar
				float diff = sceneDepth - fragDepth;
				if (diff <0){
					float t = saturate(abs(diff) / _Distance);
					return float4(_BackgroundColor.xyz, (1.0 -t));
				}
				else{
					return tex2D(_MainTex, i.uv);
				}
			};

			ENDHLSL
		}
	}
}