

Shader"ManNiu/BilinnPhongFra"{
	
	Properties{
		_MainColor ("MainColor",color ) = (1,1,1,1)
		_SpecularColor("Specular",color) = (1,1,1,1)
		_Glossiness ("Glossiness",range(1,50)) = 1
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
		float4 _SpecularColor;
		float4 _MainColor;
		float _Glossiness;



	   	struct v2f{
			float4 pos:POSITION;
			fixed3 normal:NORMAL;
			float4 vertex:COLOR;

		};


			
		v2f vert(appdata_base v){
	
			v2f o;
			o.pos =UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影

			o.normal = v.normal;//这个法向量是模型空间的 需要变换
			o.vertex= v.vertex;
			return o  ;
		}
		fixed4 frag(v2f In):COLOR{
			fixed4 col  = UNITY_LIGHTMODEL_AMBIENT;

			//Diffuse COLOR
			float3  N = UnityObjectToWorldNormal(In.normal);
			float3   L =normalize( WorldSpaceLightDir(In.vertex));
			float diffuseScale = saturate(dot(N,L));
			col+=_LightColor0*_MainColor*diffuseScale;
			//Specular Color

			float3 V =normalize( WorldSpaceViewDir(In.vertex));


			float3 R = 2*dot(N,L)*N-L;
			 float specularScale = pow(saturate(dot(R,V)),_Glossiness);
			 col+= _SpecularColor *specularScale;

			 ///Compute Spoint Lighting
			 float3 wPos = mul(unity_ObjectToWorld,In.vertex).xyz;
			 col.rgb += Shade4PointLights(unity_4LightPosX0,unity_4LightPosY0,unity_4LightPosZ0,
			unity_LightColor[0].rgb,unity_LightColor[1].rgb,unity_LightColor[2].rgb,unity_LightColor[3].rgb,
			unity_4LightAtten0,wPos,N);


			return col;
				

		}
		ENDCG
	}




	}
		



}