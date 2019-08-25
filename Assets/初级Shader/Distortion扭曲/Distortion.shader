

Shader"ManNiu/Distortion"{
	
	Properties{

	}
	SubShader{
		//Cull off  //正背面剔除
	Pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag 
		#include "UnityCG.cginc"
		
		
	   	struct v2f{
			float4 pos:POSITION;
			fixed4 color :COLOR;
		};

		v2f vert(appdata_base v){
		float angle = length(v.vertex)*_SinTime.y;
		//float angle =v.vertex.z +_Time.y; 
		  

		float4x4 m={
			float4(cos(angle),0,sin(angle),0),
			float4( 0,1,0,0),
			float4(-sin(angle),0,cos(angle),0),
			float4(0,0,0,1)
		};
		//float4x4 m={
		//	float4(sin(angle)/8+0.5,0,0,0),
		//	float4( 0,1,0,0),
		//	float4(0,0,1,0),
		//	float4(0,0,0,1)
		//};
		v.vertex = mul(m,v.vertex);

		
		//这是优化后的计算  
		float x = cos(angle)*v.vertex.x+sin(angle)*v.vertex.z;
		   float z=cos(angle)*v.vertex.z -sin(angle)*v.vertex.x;
		   v.vertex.x  = x;
		   v.vertex.z = z;



		 v2f o;
			o.pos =UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影
			o.color =fixed4(0,1,1,1);
			return o  ;
		}
		fixed4 frag(v2f In):COLOR{
			return In.color;
			//return _MainColor;
				

		}
		ENDCG
	}




	}
		



}