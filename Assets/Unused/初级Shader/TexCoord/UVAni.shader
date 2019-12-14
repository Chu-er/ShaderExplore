// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectT

Shader"ManNiu/UVAni"{
	
	Properties{
	_MainTex("MainTex",2D) =""{}
	_MainColor ("MianColor",color) = (1,1,1,1)
	_F ("F",range(0,10)) =1 
	_A("A",range(0,1)) =  0.01
	_R("R",range(0,1)) = 0
	}
	SubShader{
			Tags{"queue"="transparent"}

		Pass{

		//Blend srcalpha oneminussrcalpha
		//Zwrite off
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
	
			o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
		
			//o.uv.x *= tiling_x;
			//o.uv.y *= tiling_y;
			//o.uv.x+= offset_x;
			//o.uv.y+=offset_y;
			return o;
		}
		fixed4 frag(v2f In):COLOR{
			//In.uv += _Time.x;
			//In.uv+=sin(In.uv*3.14*_F+_Time.y)*_A;    //直接加Sin会很大 要 乘小
			float2 uv = In.uv;
			float scale=0;
			float dis = distance(uv,float2(0.5,0.5));  //pragram2 点击的位置

			//if(dis<_R){
				_A *=saturate( 1- dis/_R); //距越近越强变换
				 scale  = _A  *sin(-dis*_F*3.14+_Time.y);

				 uv =uv+uv*scale;
			//}

		
				fixed4 color= tex2D(_MainTex,uv);//+fixed4(1,1,1,1)*saturate(scale)*100;
				return color;
		}
		ENDCG
	}




	}
		



}