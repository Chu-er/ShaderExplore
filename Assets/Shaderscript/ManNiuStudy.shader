// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'




Shader"ManNiu/Today"{
	
	Properties{
		//_MainTex("")
		_MainColor("MainCol",Color) =(1,1,1,1) 


	}
	SubShader{

	Pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag 
		#include "UnityCG.cginc"
		

		float4x4 mvp;

		float4 _MainColor;//Properties 
		uniform float4 Colo;//或者使用这个方法也可以进行 ——MainCol的 操作
		


	   	struct v2f{
			float4 pos:POSITION;
			fixed4 color :COLOR;
		};

		//struct appdata_Base{
		//	float2 pos:POSITION;
		//	float4 color:COLOR;
		//	 
		//};

		v2f vert(appdata_base v){
			v2f o ; 
			float4x4 m = UNITY_MATRIX_MVP*mvp;
			o.pos =  UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影
			//o.pos = float4(v.vertex,0,1);
			float4 wpos = mul (unity_ObjectToWorld,v.vertex);//unity_ObjectToWorld 


			if(wpos.x>0)
				o.color = fixed4(1,0,0,1);
			else
				o.color = fixed4(0,0,1,1);


			return o;
		}
		fixed4 frag(v2f In):COLOR{
			return In.color;
		
	

		}
		ENDCG
	}




	}
		



}