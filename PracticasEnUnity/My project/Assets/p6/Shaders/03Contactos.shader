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
			"RenderType" = "Opaque"
			"Queue" = "Geometry"
			"RenderPipeline" = "UniversalPipeline"
		}
		Pass
		{
			Tags { "LightMode" = "UniversalForward" }
			HLSLPROGRAM

			#pragma vertex vsMain
			#pragma fragment psMain
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"

			CBUFFER_START(UnityPerMaterial)
			sampler2D _MainTex;
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
				float2 uv : TEXCOORD0;
			};

			VsOut vsMain(VsIn v) {
				VsOut o;
				o.pos = TransformObjectToHClip(v.vertex.xyz);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			float4 psMain(VsOut i) : COLOR {
				// el PS lee del zbuffer la info del objeto en primer plano.
				float3 depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, sampler_CameraDepthTexture, i.uv);

				// obtiene la distancia desde la cámara a ese punto.
				float distance = LinearEyeDepth(depth, _ZBufferParams);
				float distance2 = LinearEyeDepth(i.pos, _ZBufferParams);

				// con lo anterior calcula la distancia entre el punto que se quiere pintar y el que ya hay.
				float diff = distance - distance2;

				// La distancia calculada se utiliza con _ContactSize para determinar el valor entre
				// 0 y 1 que se utilizará para la interpolación lineal entre el color base del material
				// (textura) y el color máximo del contacto (_ContactColor)
				float t = saturate(diff / _ContactSize); // saturate deja el valor entre 0 - 1

				float4 texColor = tex2D(_MainTex, i.uv);

                // Interpolamos: cerca del contacto -> _ContactColor, lejos -> textura
                return lerp(_ContactColor, texColor, t);
				// El PS devuelve el valor de la interpolación lineal con todos Los datos calculados previamente.
			};

			ENDHLSL
		}
	}
}