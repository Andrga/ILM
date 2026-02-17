Shader "Unlit/03ComponenteFresnel"
{
    Properties
    {
        _Color ("Color", Color) = (1.0, 0.0, 0.0)
        _GlossPower("Gloss Power", Float) = 100
        _FresnelPower("Fresnel Power", Float) = 10

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
            # include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            # pragma vertex vsMain
            # pragma fragment psMain

            struct VsIn {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct VsOut {
                float4 pos : SV_POSITION;

                float3 normalWS : POSITION1;
                float3 view: POSITION2;
            };

            CBUFFER_START(UnityPerMaterial)
            float4 _Color;
            float _GlossPower;
            float _FresnelPower;
            CBUFFER_END

            VsOut vsMain ( VsIn v )
            {
                VsOut o ;
                o.pos = TransformObjectToHClip(v.vertex.xyz);
                
                o.normalWS = TransformObjectToWorldNormal(v.normal);

                float4 positionWS = mul(unity_ObjectToWorld, v.vertex);
                o.view = GetWorldSpaceNormalizeViewDir(positionWS.xyz);
               
                return o;
            }

            float4 psMain (VsOut i) : SV_TARGET {
                float3 ambient = half3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);

                Light mainLight = GetMainLight();
                float mainLightIntensity = max(0, dot(i.normalWS, mainLight.direction));
                float3 diffuse = mainLight.color * mainLightIntensity;

                float4 diffuseLighting = float4(ambient + diffuse, 1);

                float3 r = 2 * dot (i.normalWS, mainLight.direction) * i.normalWS - mainLight.direction ;

                float specular = max(0, dot(i.view, r));
                specular = pow(specular, _GlossPower);
                float3 specularColor = mainLight.color * specular;
                float4 specularLighting = float4(specularColor, 1.0);

                float3 fresnel = mainLight.color * pow(1 - dot(i.normalWS, i.view), _FresnelPower);

                return _Color * diffuseLighting + specularLighting + float4(fresnel, 1);
            }

            ENDHLSL 
        }
    }
}
