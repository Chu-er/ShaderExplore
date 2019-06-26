

Shader"ManNiu/BilinnPhong"{
	
	Properties{
		_Specular("Specular",color)=(1,1,1,1)
		_Glossness("Glossness",range(1,20)) = 9
	}
	SubShader{
		//Cull off  //正背面剔除


	Pass{


		Tags{"LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag 
		#include "UnityCG.cginc"
		//#include "UnityLightingCommon.cginc"
		#include "lighting.cginc" //上面也可以
		float4 _Specular;
		float _Glossness;
	   	struct v2f{
			float4 pos:POSITION;
			fixed4 color :COLOR;
		};


			
		v2f vert(appdata_base v){
	
			v2f o;
			o.pos =UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影


			float3 N = (UnityObjectToWorldNormal(v.normal));// 需要变换到世界空间  这个函数已经做规范化了
			float3 L =normalize(WorldSpaceLightDir(v.vertex));
			float V  =normalize(WorldSpaceViewDir(v.vertex));
				
			//环境光
			o.color= UNITY_LIGHTMODEL_AMBIENT;
			//Didduse Color
			float angle  =saturate( dot(N,L));
			 o.color =_LightColor0*angle;
		
			//相加得到半角  BilinnPhong
			float3 H  = L+V;
			H=normalize(H);
			 float specularScale =pow( saturate(dot(N,H)),_Glossness);
			 o.color.rgb +=_Specular*specularScale;			
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