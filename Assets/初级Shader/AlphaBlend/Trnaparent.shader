// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectT

Shader"ManNiu/Tranparent"{
	
	Properties{
	_MainTex("MainTex",2D) =""{}
	_MainColor ("MianColor",color) = (1,1,1,1)
	_F ("F",range(0,10)) =1 
	}
	SubShader{
			Tags{"queue"="transparent"}

		Pass{

		Blend Srcalpha OneMinussrcalpha
		//Zwrite off
		Ztest Greater                         //小于等于 Lequal 大于  Greater
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag 
		#include "UnityCG.cginc"

		//float tiling_x;
		//float tiling_y;
		//float offset_x;
		//float offset_y;
	
		float4 _MainColor;//Properties 
		sampler2D _MainTex;
		float4 _MainTex_ST;//固定值
		float _F;
		float _A;
		float _R;
	   	struct v2f{
			float4 pos:POSITION;
			float2 uv:TEXCOORD0;
		};

		v2f vert(appdata_base v){
			v2f o ; 
			
			o.pos =  UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影
			return o;
		}
		fixed4 frag(v2f In):COLOR{
			fixed4 color  =fixed4(0,0,1,0.5);
			return color;

		}
		ENDCG
	}
		Pass{

		//Blend Srcalpha OneMinussrcalpha 没有必要去混和 只显示上部分
		//Zwrite off
		Ztest Less                         //小于等于 Lequal 大于  Greater
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag 
		#include "UnityCG.cginc"

		//float tiling_x;
		//float tiling_y;
		//float offset_x;
		//float offset_y;
	
		float4 _MainColor;//Properties 
		sampler2D _MainTex;
		float4 _MainTex_ST;//固定值
		float _F;
		float _A;
		float _R;
	   	struct v2f{
			float4 pos:POSITION;
			float2 uv:TEXCOORD0;
		};

		v2f vert(appdata_base v){
			v2f o ; 
			
			o.pos =  UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影
			return o;
		}
		fixed4 frag(v2f In):COLOR{
			fixed4 color  =fixed4(1,0,0,1);
			return color;

		}
		ENDCG
	}



	}
}