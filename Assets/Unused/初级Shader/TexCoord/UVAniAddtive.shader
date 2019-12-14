// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectT

Shader"ManNiu/UVAniAddtive"{
	
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

		v2f vert(appdata_full v){
			v2f o ; 
			
			o.pos =  UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影
	
			//o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
			o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);

			return o;
		}
		fixed4 frag(v2f In):COLOR{
				//float2 uv = In.uv;
				//fixed4 color= tex2D(_MainTex,uv);//+fixed4(1,1,1,1)*saturate(scale)*100;
				//uv.x=In.uv.x+0.001;
				//color.rgb+=tex2D(_MainTex,uv);
				//uv.x=In.uv.x-0.001;
				//color.rgb+=tex2D(_MainTex,uv);
				//
				//
				//
				//color.rgb/=3;

				////模糊处理
				fixed4 color = tex2D(_MainTex,In.uv,float2(0.01,0.01),float2(0.01,0.01));
				return color;
		}
		ENDCG
	}




	}
		



}