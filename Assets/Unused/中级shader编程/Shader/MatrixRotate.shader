Shader "Custom/MatrixRotate"
{
	Properties
	{
		[PreRendererDate]_MainTex ("Texture", 2D) = "white" {}
		_RotScale("Rot Scale",Range(0,100)) = 10
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha 
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
			float _RotScale;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
			
				return o;
			}
			static float2 center = {0.5,0.5};
		
			fixed4 frag (v2f i) : SV_Target
			{

				float2 uv =i.uv;
				//得到指向中心坐标得向量
				//float2 dt =center-uv;
				 float2 dt =uv-center; 
				//求距离  对自己点积就是 X^2 * Y^2 然后开平方得到距离
				//float len =sqrt( dot(dt,dt));
					float len =length(dt);
				
				////弧度值  
				float radian= (1-len)*_RotScale;
				//旋转矩阵Z Axis 
				 float2x2 rot=
				{
					cos(radian),sin(radian),
					-sin(radian),cos(radian)

				};

				dt = mul(rot,dt);
				uv = dt+center;

				
				fixed4 col = tex2D(_MainTex, uv);
				
				
				return col;
			}
			ENDCG
		}
	}
}
