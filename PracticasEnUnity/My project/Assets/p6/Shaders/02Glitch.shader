Shader "Unlit/02Glitch"
{
    Properties
    {
        [IntRange] _MaxDesplX("Maximo glitch horizontal (pixeles)", Range(0, 100)) = 10
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        Pass
        {
            HLSLPROGRAM
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareOpaqueTexture.hlsl"

            #pragma vertex vsMain
            #pragma fragment psMain  

            CBUFFER_START(UnityPerMaterial)
            int _MaxDesplX;
            CBUFFER_END

            struct VsIn
            {
                float4 vertex : POSITION;
            };
            
            struct VsOut
            {
                float4 pos : SV_POSITION;
                float4 posSS : TEXCOORD0;
            };

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

            VsOut vsMain (VsIn v)
            {
                VsOut o;
                o.pos = TransformObjectToHClip(v.vertex.xyz);
                o.posSS = ComputeScreenPos(o.pos);
                return o;
            }


            float4 psMain ( VsOut i) : SV_TARGET {
                float2 screenUV = i.posSS / i.posSS.w;
                float2 screenXY = screenUV * _ScreenParams.xy;

                //float desp = unity_gradientNoise(float2(0, screenXY.y)) * _MaxDesplX;
                float desp = unity_gradientNoise(float2(0, screenXY.y)) * (_Time.w - trunc(_Time.w));
                desp += _MaxDesplX;
                screenUV.x *= desp;
                
                return float4(SampleSceneColor(screenUV),1.0f);
            }
            ENDHLSL
        }
    }
}
