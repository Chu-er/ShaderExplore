

Shader"ManNiu/Wave"{
	
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
		//y方向的变换
		//float up = sin(v.vertex.x)+_Time.y;
		//	float4x4 m={
		//	float4(1,0,0,0), //X不动
		//	float4(0,sin(up)/8+0.5,0,0),
		//	float4(0,0,1,0),
		//	float4(0,0,0,1)
		// };
		 //v.vertex = mul(m,v.vertex);
		// v.vertex. y +=sin(v.vertex.x+_Time.y)*0.3; //0.3 控制振幅   旗帜飘扬
		 // v.vertex. y +=sin(-length(v.vertex.xz)+_Time.y)*0.3; //中心到边缘 或者取反
		  v.vertex. y +=sin((v.vertex.x+v.vertex.z)+_Time.y)*0.2; 
		    v.vertex. y +=sin((v.vertex.x-v.vertex.z)+_Time.y)*0.2; 
		 v2f o;
			o.pos =UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影
			//o.color =fixed4(v.vertex.y ,v.vertex.y ,v.vertex.y,1);
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