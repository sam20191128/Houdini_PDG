Shader "BoatAttack/Water"
{
    Properties
    {
        _NormalMap("NormalMap",2D) = "bump"
    }
    SubShader
    {
        Pass
        {
            Tags
            {
                "LightMode" = "UniversalForward"
            }
            HLSLPROGRAM
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #pragma vertex vert
            #pragma fragment frag

            TEXTURE2D(_ReflectionMap);
            SAMPLER(sampler_ReflectionMap);


            struct appdata // vert struct
            {
                float4 vertex : POSITION; // vertex positions
                float2 texcoord : TEXCOORD0; // local UVs
            };

            struct v2f // fragment struct
            {
                float4 uv : TEXCOORD0; // Geometric UVs stored in xy, and world(pre-waves) in zw
                float3 worldPos : TEXCOORD1; // world position of the vertices
                float4 screenPos : TEXCOORD2; // for ssshadows
                float4 clipPos : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.uv.xy = v.texcoord;
                o.worldPos = TransformObjectToWorld(v.vertex.xyz);
                o.clipPos = TransformWorldToHClip(o.worldPos);
                o.screenPos = ComputeScreenPos(o.clipPos);
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(IN);
                half3 screenUV = i.screenPos.xyz / i.screenPos.w; //screen UVs
                half3 normal = float3(0, 1, 0);
                half2 reflectionUV = screenUV + normal.zx * half2(0.02, 0.15);
                half3 reflection = SAMPLE_TEXTURE2D_LOD(_ReflectionMap, sampler_ReflectionMap, reflectionUV, 0).rgb;
                return half4(reflection, 1);
            }
            ENDHLSL
        }
    }
}