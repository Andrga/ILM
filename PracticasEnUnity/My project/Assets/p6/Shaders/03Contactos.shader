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
			float4 psMain(VsOut i) : COLOR {				
                float2 screenUV = i.posSS / i.posSS.w;
				// el PS lee del zbuffer la info del objeto en primer plano.
				float distance = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, sampler_CameraDepthTexture, screenUV), _ZBufferParams);

				// obtiene la distancia desde la cámara a ese punto.
				//float distance = LinearEyeDepth(depth, _ZBufferParams);
				float distance2 = i.pos.z;

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