// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectT

Shader"ManNiu/TextureBlend"{
	
	Properties{
	
	_MainTex("MainTex",2D) =""{}
	_SecondTex("SecondTex",2D) =""{}
	_F ("F",range(0,10)) =1 
	}
	SubShader{
			Tags{"queue"="transparent"}

		Pass{

		//Blend srcalpha oneminussrcalpha
		//Zwrite off
		ColorMask r 
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag 
		#include "UnityCG.cginc"

		//float tiling_x;
		//float tiling_y;
		//float offset_x;
		//float offset_y;
	
		sampler2D _MainTex;
		sampler2D _SecondTex;
		float4 _MainTex_ST;//固定值
		float _F;

	   	struct v2f{
			float4 pos:POSITION;
			float2 uv:TEXCOORD0;
		};

		v2f vert(appdata_base v){
			v2f o ; 
			
			o.pos =  UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影
	
			o.uv=v.texcoord;//.xy*_MainTex_ST.xy+_MainTex_ST.zw;
		
			//o.uv.x *= tiling_x;
			//o.uv.y *= tiling_y;
			//o.uv.x+= offset_x;
			//o.uv.y+=offset_y;
			return o;
		}
		fixed4 frag(v2f In):COLOR{
			fixed4 mainColor = tex2D(_MainTex,In.uv);

			float offset_uv = 0.05*(In.uv*_F +_Time.x*2);
			float2 uv = In.uv+offset_uv;
			fixed4 color_1 =  tex2D(_SecondTex,uv);


			mainColor *= color_1.b;
			return mainColor;
			
		}
		ENDCG
	}




	}
		



}