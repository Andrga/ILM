Shader "Unlit/08Explotando"
{
    Properties
    {
        _Color("Color", Color) = (1.0 , 1.0 , 0.0)   
        _Scale("Scale", float) = 0.10
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
            Tags {"LightMode" = "UniversalForward"}

            HLSLPROGRAM
            # include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            # pragma vertex vsMain
            # pragma fragment psMain

            struct VsIn {
                float4 vertex : POSITION ;
                float3 normal : NORMAL;
            };
            struct VsOut {
                float4 pos : SV_POSITION ;
            };

            CBUFFER_START(UnityPerMaterial)
            float4 _Color;
            float _Scale;
            CBUFFER_END

            VsOut vsMain ( VsIn v )
            {
                VsOut o ;
                float3 explosion = v.normal * abs(_SinTime.w) * _Scale;
                o.pos = TransformObjectToHClip(v.vertex.xyz + explosion);
                return o ;
            }


            float4 psMain (VsOut i) : SV_TARGET
            {
                return _Color;
            }

            ENDHLSL 
        }
    }
    Fallback Off
}
