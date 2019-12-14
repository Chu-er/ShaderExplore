

Shader"ManNiu/Specular"{
	
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


			float3 N = normalize(v.normal);//这个法向量是模型空间的 需要变换
			float3 L =normalize(_WorldSpaceLightPos0);
			N = mul(float4(N,0),unity_WorldToObject).xyz ;
			N = normalize(N);
			//Didduse Color
			float angle  =saturate( dot(N,L));
		 o.color =_LightColor0*angle;
		
				///Specular Color
				//float3 wPos = mul(unity_ObjectToWorld,v.vertex).xyz;

				//需要世界空间中入射光的信息  从光指向顶点 所以顶点是被减数
			float3 I = WorldSpaceLightDir(v.vertex);
			float3 R=reflect(I,N);

				//View 
			 float3 V =WorldSpaceViewDir(v.vertex);
			 R = normalize(R);
			 V =normalize(V);
			 float specularScale =pow( saturate(dot(R,V)),_Glossness);
			 o.color.rgb +=_Specular*specularScale;			
				return o  ;
		}
		fixed4 frag(v2f In):COLOR{
			return In.color+UNITY_LIGHTMODEL_AMBIENT;
			//return _MainColor;
				

		}
		ENDCG
	}




	}
		



}