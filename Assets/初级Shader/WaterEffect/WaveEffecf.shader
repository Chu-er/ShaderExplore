// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectT

Shader"ManNiu/WaveEffect"{
	
	Properties{
	[PreRenderData]_MainTex("MainTex",2D) =""{}
	
	///振幅
	_Amount ("Amount",Range(0,1)) = 0.2
	//频率
	_W("W",Range(0,200)) = 50
	//衰减速度
	_Speed("_Speed",Range(0,500)) = 50
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

		float _Amount;
		float _W;
		float _Speed;
		float4 _MainColor;//Properties 
		sampler2D _MainTex;
		float4 _MainTex_ST;//固定值
		
	   	struct v2f{
			float4 pos:POSITION;
			float2 uv:TEXCOORD0;
		};

		v2f vert(appdata_base v){
			v2f o ; 
			float s;
			float c;
			sincos(radians(-90),s,c);
			float3x3 rotation=
			{
				c,s,0,
				-s,c,1,
				0,0,0
			};
			float3 vertex =  mul(rotation,v.vertex.xyz);
			o.pos =UnityObjectToClipPos(vertex);   //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影
	
			o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
		
			//o.uv.x *= tiling_x;
			//o.uv.y *= tiling_y;
			//o.uv.x+= offset_x;
			//o.uv.y+=offset_y;
			return o;
		}
		fixed4 frag(v2f In):COLOR{
		//衰减值
			// Amount = Amount/（speed*length）
			float2 center ={0.5,0.5};
			float2 uv = In.uv;
			float2 dt= center-uv;

			float len = length(dt);
			float amount =_Amount/(0.001+len*_Speed);
			if (amount <0.1){
			 amount =0;
			}
			uv.x+= 2*amount* sin(len*_W*UNITY_PI);
			uv.y+= amount* sin(len*_W*UNITY_PI);
				fixed4 color= tex2D(_MainTex,uv);//+fixed4(1,1,1,1)*saturate(scale)*100;
				return color;
		}
		ENDCG
	}




	}
		



}