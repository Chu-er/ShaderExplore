Shader "Hidden/CenterClip"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ClipRandius("ClipRadius",Range(0,1)) = 0.2
		_MaskTex("MaskTex",2D) ="black"{}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			//Blend SrcAlpha OneMinusSrcAlpha
			//Blend One OneMinusDstAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			float _ClipRandius;
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
			sampler2D _MaskTex;
			fixed4 frag (v2f i) : SV_Target
			{
				float dis = length( i.uv-fixed2(0.5,0.5));
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 col1 =  tex2D(_MaskTex, i.uv);


				// 
				//clip(saturate(1-dis)-_ClipRandius);
			clip(1-dis-_ClipRandius);
				clip(1-col1.a-0.01);
				return col;
			}
			ENDCG
		}
	}
}
