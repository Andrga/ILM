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
				float2 uv : TEXCOORD0;
                float4 posSS : TEXCOORD1;
			};

			VsOut vsMain(VsIn v) {
				VsOut o;
				o.pos = TransformObjectToHClip(v.vertex.xyz);
                o.posSS = ComputeScreenPos(o.pos);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			float4 psMain(VsOut i) : COLOR {
				// 
				//ESTA MAL!!
    //             float2 screenUV = i.posSS.xy / i.posSS.w;
	//				leer del zbuffer lo que habia antes y calcular la distancia con LinearEyeDepth
	//				sacar la siguiente distancia usando la posicion i.pos y LinearEyeDepth.
	//				Si la distancia  es menor que _ContactSize  pinta un lerpeo con el color, si no amarillo
    //             // Convertimos a distancia lineal desde la camara 
				// //	https://docs.unity3d.com/Manual/SL-BuiltinFunctions.html		= doc LinearEyeDepth
				// //	https://docs.unity3d.com/Manual/SL-UnityShaderVariables.html	= doc _ZBufferParams
    //             // lo cerca que esta el pixel del contacto
    //             float t = saturate(diff / _ContactSize); // saturate deja el valor entre 0 - 1

    //             float4 texColor = tex2D(_MainTex, i.uv);

    //             // Interpolamos: cerca del contacto -> _ContactColor, lejos -> textura
    //             return lerp(_ContactColor, texColor, t);
				
				return tex2D(_MainTex, i.uv);
			};

			ENDHLSL
		}
	}
}