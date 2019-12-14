



Shader "MyUnlit/GaussianBlur"

{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		//_offsets("Offset",Vector) =(5,5,0,0)
	}
	SubShader
	{
		Tags{"RenderType" ="Opque"}
		CGINCLUDE   //CGINCLUDE中的代码可被其他Pass重复调用，用于简化不必要的重复代码
		

			#include "UnityCG.cginc"


			sampler2D _MainTex;
			half4  _MainTex_TexelSize; //对应纹理的像素
			float4 _offsets; 
			struct appdata
			{
				float4 vertex:POSITION;
				float2 uv:TEXCOORD0;
			};


			struct v2f 
			{	
				
				UNITY_FOG_COORDS(1)//声明一个float 记录全局雾效浓度参数，默认名称就是fogCoord
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
				float4 uv1:TEXCOORD1;//一个Vector4 存储两个UV 坐标
				float4 uv2 :TEXCOORD2;
				float4 uv3:TEXCOORD3;
				
			};
		
		static float4 rowCloum  = {1,1,-1,-1};
			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o. uv = v.texcoord.xy;

				//计算偏移值  结果 可能为 （1，0，0，0） 或者（0，1，0，0） 这样表示横向和纵向 
				//只有XY 会变话   zw 摆设
				 _offsets*= _MainTex_TexelSize.xyxy;

				 // ——offset* float4(1,1,-1,-1) 可能为（1，0，-1，0） 或者（0，1，0，-1） 
				 //
				 o.uv1 = v.texcoord.xyxy +_offsets.xyxy*rowCloum;
				 o.uv2 = v.texcoord.xyxy+_offsets.xyxy*rowCloum*2;//2倍
				  o.uv3 = v.texcoord.xyxy+_offsets.xyxy*rowCloum*3;//2倍

				return o;
			}
			fixed4 frag(v2f In):SV_TARGEt{

				fixed4 color = {0,0,0,0};
				color+=0.4*tex2D(_MainTex,In.uv);
				color+=0.15*tex2D(_MainTex,In.uv1.xy);
				color+=0.15*tex2D(_MainTex,In.uv1.zw);
				color+=0.1*tex2D(_MainTex,In.uv2.xy);
				color+=0.1*tex2D(_MainTex,In.uv2.zw);
				color+=0.05*tex2D(_MainTex,In.uv3.xy);
				color+=0.05*tex2D(_MainTex,In.uv3.zw);

				return color;

			}
			


		ENDCG
		
		Pass
		{
			Cull off
			ZTest Always
			Fog{Mode off }
			NAME"GAUSSIANBLURPASS"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}
	}
	Fallback off
}
