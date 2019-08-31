Shader "Hidden/OutLine"
{
	Properties
	{
		[PreRenderData]_MainTex ("Texture", 2D) = "white" {}
		_Color("TintColor",Color) =(1,1,1,1)//图像回合颜色
		_OutLineColor("OutLine",Color) = (1,1,1,1)
		_CheckRange("CheckRange",float)  =1
		_CheckAccuracy("Accuracy",float) =0.5 //检测精确度
		_LineWidth("LineWidth",float)=1
	}
	SubShader
	{

		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}

		// No culling or depth
		Cull Off ZWrite Off 
		Blend One OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
		
			#include "UnityCG.cginc"
				sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			
			fixed4 _Color;
			fixed4 _OutLineColor;
			float _CheckAccuracy;
			float _LineWidth;
			float _CheckRange;


			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 color:COLOR;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 color:COLOR;
		
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.color= 	v.color* _Color;
				
				return o;
			}
			
		

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col.rgb *=col.a; 

				//col.a  > 1/LineWidth      return 1
				float isOut = step(abs(1/_LineWidth),col.a);

				if (isOut !=0){
					fixed4 pixelUp = tex2D(_MainTex,i.uv+ float2(0,_MainTex_TexelSize.y*_CheckRange));
					fixed4 pixelDown = tex2D(_MainTex,i.uv- float2(0,_MainTex_TexelSize.y*_CheckRange));
					fixed4 pixelLeft = tex2D(_MainTex,i.uv- float2(_MainTex_TexelSize.x*_CheckRange,0));
					fixed4 pixelRight = tex2D(_MainTex,i.uv+ float2(_MainTex_TexelSize.x*_CheckRange,0));
					float bOut = step(1-_CheckAccuracy,pixelUp.a*pixelDown.a*pixelLeft.a*pixelRight.a);
					return lerp(_OutLineColor,col,bOut);

				}
				return col;
			}
			ENDCG
		}
	}
}
