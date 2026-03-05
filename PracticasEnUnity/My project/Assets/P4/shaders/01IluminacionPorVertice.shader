Shader "Unlit/01IluminacionPorVertice"
{
    Properties
    {
        _Color ("Color", Color) = (1.0, 0.0, 0.0)
        _GlossPower("Gloss Power", Float) = 100

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
                float4 diffuseLighting : COLOR;
                float4 specularLighting : TEXCOORD1;
            };

            CBUFFER_START(UnityPerMaterial)
            float4 _Color;
            float _GlossPower;
            CBUFFER_END

            VsOut vsMain ( VsIn v )
            {
                VsOut o ;
                o.pos = TransformObjectToHClip(v.vertex.xyz);
                float3 ambient = half3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);
                
                float3 normalWS = TransformObjectToWorldNormal(v.normal);
                Light mainLight = GetMainLight();
                float mainLightIntensity = max(0, dot(normalWS, mainLight.direction));
                float3 diffuse = mainLight.color * mainLightIntensity;

                o.diffuseLighting = float4(ambient + diffuse, 1);

                // Specular ( version de Phong )
                float4 positionWS = mul(unity_ObjectToWorld, v.vertex);
                float3 view = GetWorldSpaceNormalizeViewDir(positionWS.xyz);
                float3 r = 2 * dot (normalWS, mainLight.direction) * normalWS - mainLight.direction ;

                float specular = max(0, dot(view, r));
                specular = pow(specular, _GlossPower);
                float3 specularColor = mainLight.color * specular;
                o.specularLighting = float4(specularColor, 1.0);
               
                return o;
            }

            float4 psMain (VsOut i) : SV_TARGET {
                return _Color * i.diffuseLighting + i.specularLighting;
            }

            ENDHLSL 
        }
    }
}
