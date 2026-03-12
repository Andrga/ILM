Shader "Unlit/03Contactos"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "" {}
		_ContactColor("Color de contacto", Color) = (1.0, 1.0, 0.0)
		_ContactSize("Tam. del contacto", Range(0.01, 100)) = 0.25
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

			HLSLPROGRAM

			#pragma vertex vsMain
			#pragma fragment psMain
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"

			sampler2D _MainTex; 
			CBUFFER_START(UnityPerMaterial)
			float4 _MainTex_ST;
			float4 _ContactColor;
			float _ContactSize;
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

				// Franja exacta del tamanyo de _ContactSize (0-1)
				float t = saturate(diff / _ContactSize);

				float4 texColor = tex2D(_MainTex, i.uv);
				// color (0-t) + texColor (t-1)
				return (_ContactColor * (1-t)) + (texColor *  t);
			};

			ENDHLSL
		}
	}
}