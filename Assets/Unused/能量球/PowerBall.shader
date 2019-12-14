Shader "Hidden/PowerBall"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SpeedX("Speed",Range(0,3))= 1
			_SpeedY("SpeedY",Range(0,3))= 1
			_NoiseTex ("NoiseTex",2D) ="white"{}
		_NoiseStrength("NoiseStrength",Range(0,5))=1
	}
	SubShader
	{
		// No culling or depth
		Cull Off 

		Pass
		{
		Blend One One
			Tags
			{
				"Queue" = "Transparent"
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _NoiseTex;
			float4 _MainTex_ST;
			float4 _NoiseTex_ST;
			float _SpeedX;
			float _SpeedY;
			float _NoiseStrength;
			fixed4 frag (v2f i) : SV_Target
			{

				
				float2 FlowUV = (i.uv+float2(_SpeedX*_Time.y,_Time.y*_SpeedY));
				float4 _NoiseMap_var =tex2D(_NoiseTex,TRANSFORM_TEX(FlowUV,_NoiseTex));
				float2 NoiseUV =i.uv+ float2(_NoiseMap_var.r,_NoiseMap_var.b)*_NoiseStrength;

				float4 finalCol=tex2D(_MainTex,TRANSFORM_TEX(NoiseUV,_MainTex));


		
				
				return finalCol;
			}
			ENDCG
		}
	}
}
