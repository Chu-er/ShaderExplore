

Shader"ManNiu/Diffuse"{
	
	Properties{
		
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
	   	struct v2f{
			float4 pos:POSITION;
			fixed4 color :COLOR;
		};


			
		v2f vert(appdata_base v){
	
			v2f o;
			o.pos =UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影

			float3 N = normalize(v.normal);//这个法向量是模型空间的 需要变换
			float3 L =normalize(_WorldSpaceLightPos0);
			///方案1 把光向量变换到模型空间里面
			// L=mul(unity_WorldToObject,float4(L,0)).xyz ;  //结果转换为3维向量 

			 ///方案2 b把法向量转换到世界空间
			//N = mul(unity_ObjectToWorld,float4(N,0)).xyz ;  //结果转换为3维向量 

			///FIXBUG 法线不是 等比列缩放的时候 受到的光会产生极大偏差  需要用逆矩阵的转置矩阵 
			// 
			N = mul(float4(N,0),unity_WorldToObject).xyz ;
			N = normalize(N);
			float angle  =saturate( dot(N,L));
			o.color =_LightColor0*angle;
			//o.color.rgb += ShadeVertexLights(v.vertex,v.normal); //+=可以将平行光的算法也计算进去 但要使用Vertex Pass
			float3 wPos = mul(unity_ObjectToWorld,v.vertex).xyz;

			o.color.rgb += Shade4PointLights(unity_4LightPosX0,unity_4LightPosY0,unity_4LightPosZ0,
			unity_LightColor[0].rgb,unity_LightColor[1].rgb,unity_LightColor[2].rgb,unity_LightColor[3].rgb,
			unity_4LightAtten0,wPos,N);
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