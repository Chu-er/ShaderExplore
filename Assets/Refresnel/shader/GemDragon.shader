Shader "Custtom/DragonGlass"
{
	Properties
	{
	
		_Cube("Cube",Cube) = ""{}
		_EtaRadio("EtaRadio",Range(0,1)) = 0
		_FresnelBias("FresnelBias",float) = .5
		_FresnelScale("FresnelScale",float)   = .5
		_FresnelPower("FresnelPower",float)  = .5


	}
	SubShader
	{

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			samplerCUBE _Cube;
			float _FresnelBias;
			float _EtaRadio;
			float _FresnelPower;
			float _FresnelScale;


			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal:NORMAL;
			};

			struct v2f
			{
				
				float4 vertex : SV_POSITION;
				float3 normalDir:TEXCOORD0;
				float3 viewDir:TEXCOORD1;

			};

		
			v2f vert (appdata v)
			{
				v2f o;
				o.viewDir  = WorldSpaceViewDir(v.vertex);
				o.normalDir = UnityObjectToWorldNormal(v.normal);
				o.vertex = UnityObjectToClipPos(v.vertex);

	
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				
				float3 reflectDir  = reflect(-normalize(i.viewDir),i.normalDir);
				fixed4 reflectCol = texCUBE(_Cube,reflectDir);

				float3 refractDir  = refract(-normalize(i.viewDir),i.normalDir,_EtaRadio);

				fixed4 refractCol = texCUBE(_Cube,refractDir);

				float fresnel =max(0, min(1,_FresnelBias+_FresnelScale*pow(min(0,1-dot(normalize(i.viewDir),i.normalDir)),_FresnelPower)));



				return lerp(refractCol,reflectCol,fresnel);
			}
			ENDCG
		}
	}
}
