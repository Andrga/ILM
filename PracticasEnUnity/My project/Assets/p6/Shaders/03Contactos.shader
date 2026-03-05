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

			CBUFFER_START(UnityPerMaterial)
			sampler2D _MainTex;
			float4 _MainTex_ST;
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
				return tex2D(_MainTex, i.uv);
			};

			ENDHLSL
		}
	}
}