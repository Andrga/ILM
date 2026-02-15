Shader "Unlit/06Desaparicion"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "" {}
        _CutThresold("Cutoff thresold", float) = 0.0
        _CutHeight("Cutoff height", float) = 0.0
        _NoiseScale("Noise Scale", float) = 20
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
            "RenderPipeline" = "UniversalPipeline"
        }
        Pass
        {
            name "Pasada1"
            Cull Off
            Tags {"LightMode" = "UniversalForward"}

            HLSLPROGRAM
            # include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            # pragma vertex vsMain
            # pragma fragment psMain
            
            float2 unity_gradientNoise_dir(float2 p)
            {
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            float unity_gradientNoise(float2 p)
            {
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(unity_gradientNoise_dir(ip), fp);
                float d01 = dot(unity_gradientNoise_dir(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(unity_gradientNoise_dir(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(unity_gradientNoise_dir(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                return lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x);
            }

            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            {
               Out = unity_gradientNoise(UV * Scale) + 0.5; 
            }

            struct VsIn {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            struct VsOut {
                float4 pos : SV_POSITION;
                float4 localPos : POSITION1;
                float2 uv : TEXCOORD0;
            };

            CBUFFER_START(UnityPerMaterial)
            sampler2D _MainTex;
            float _CutThresold;
            float _CutHeight;
            float _NoiseScale;
            CBUFFER_END

            VsOut vsMain ( VsIn v )
            {
                VsOut o ;
                o.pos = TransformObjectToHClip(v.vertex.xyz);
                o.localPos = v.vertex;
                o.uv = v.uv;
                return o ;
            }

            float4 psMain (VsOut i) : SV_TARGET
            {
                float noise;
                Unity_GradientNoise_float(i.uv, _NoiseScale, noise);
                noise = (noise * 2) - 1;

                i.localPos.y += noise * _CutHeight;

                if( i.localPos.y > _CutThresold ) {
                    discard;
                }

                return tex2D(_MainTex, i.uv);
            }

            ENDHLSL 
        }
    }
}
