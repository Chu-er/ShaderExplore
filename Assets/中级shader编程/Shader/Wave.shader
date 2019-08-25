Shader "Custom/Wave"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		
	}
	SubShader
	{
		Tags { "Queue"="Transparent" }
		LOD 100

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha 
			//Cull off
			ZTest always

			ZWrite off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
		
			
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

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
			
				return o;
			}
	
		static	float3 rate  ={0.6,0.3,0.1};
		//static	float3 rate  ={1,0.6,0.5};

			fixed4 frag (v2f i) : SV_Target
			{
				
				fixed4 col = tex2D(_MainTex,i. uv);
				float gray = dot(rate,col.rgb);
				float value = gray-_Time.y;

				//if ( gray-_Time.y<0){
				//	discard;
				//}
				clip( value-0);
				return col;
			}
			ENDCG
		}
	}
}
