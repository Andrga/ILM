Shader "Unlit/01Lunares"
{
    Properties
    {
        [IntRange] _Dist("Distancia entre circulos", Range(0, 100)) = 20
        [IntRange] _Radio("Radio", Range(0, 50)) = 6
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
            int _Dist;
            int _Radio;
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
                
                int x = screenXY.x / _Dist;
                int y = screenXY.y / _Dist;
                float centX = x *_Dist + _Dist/2;
                float centY = y *_Dist + _Dist/2;

                float3 claro = SampleSceneColor(screenUV);
                float3 oscuro = _MaxDesplXr(screenUV)*0.5f;

                if (distance(float2(centX, centY) , screenXY) < _Radio){
                    return float4(oscuro, 1);
                    }
                else{
                    return float4(claro, 1);
                    }
            }
            ENDHLSL
        }
    }
}
