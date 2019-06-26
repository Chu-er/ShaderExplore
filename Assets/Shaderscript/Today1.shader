// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'




Shader"ManNiu/Today1"{
	
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

		v2f vert(appdata_base v){
			v2f o ; 
			float4x4 m = UNITY_MATRIX_MVP*mvp;
			o.pos =  UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影

			float x  =o.pos.x/o.pos.w;   //得到投影坐标
			if (x<=-1) //先使用X分量来判断
				o.color = fixed4(1,0,0,1);
			else if(x>=1)
				o.color = fixed4(0,0,1,1);
			else
				o.color= fixed4(x/2+0.5,x/2+0.5,x/2+0.5,1);

			return o;
		}
		fixed4 frag(v2f In):COLOR{
			return In.color;
		
	

		}
		ENDCG
	}




	}
		



}