

Shader"ManNiu/BilinnPhongShadow"{
	
	Properties{
		_MainColor("MianColor",color) = (1,1,1,1)
		_Specular("Specular",color)=(1,1,1,1)
		_Glossness("Glossness",range(1,20)) = 9

	}
	SubShader{
		//Cull off  //正背面剔除

	Pass{
		//Tags{"lightMode" = "shadowcaster"}

	}
	Pass{


		Tags{"LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag 
		#pragma multi_compile_fwdbase 
		#include "UnityCG.cginc"
		//#include "UnityLightingCommon.cginc"
		#include "lighting.cginc" //上面也可以
		#include "AutoLight.cginc"
		fixed4 _MainColor;
		float4 _Specular;
		float _Glossness;
	   	struct v2f{
			float4 pos:POSITION;
			fixed4 color :COLOR;
			//unityShadowCoord3 _ShadowCoord : TEXCOORD0;
			//unityShadowCoord3 _LightCoord : TEXCOORD1;
			LIGHTING_COORDS(0,1)
			
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
			 o.color +=_LightColor0*angle*_MainColor;
		
			//相加得到半角  BilinnPhong
			float3 H  = L+V;
			H=normalize(H);
			 float specularScale =pow( saturate(dot(N,H)),_Glossness);
			 o.color.rgb +=_Specular*specularScale;		
			 
			 TRANSFER_VERTEX_TO_FRAGMENT(o) //在宏定义已经有分号了  不用加了 AutoLightShadow .cginc
				return o  ;
		}
		fixed4 frag(v2f In):COLOR{
			float atten = LIGHT_ATTENUATION(In);
			In.color.rgb*= atten;
			return In.color;
			//return _MainColor;
				

		}
		ENDCG
	}
	//////******************************************************
		Pass{


		Tags{"LightMode"="ForwardAdd"}
		Blend one one 
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag 
		#pragma multi_compile_fwdadd_fullshadows  
		#include "UnityCG.cginc"
		//#include "UnityLightingCommon.cginc"
		#include "lighting.cginc" //上面也可以
		#include "AutoLight.cginc"
		fixed4 _MainColor;
		float4 _Specular;
		float _Glossness;
	   	struct v2f{
			float4 pos:POSITION;
			fixed4 color :COLOR;
			//unityShadowCoord3 _ShadowCoord : TEXCOORD0;
			//unityShadowCoord3 _LightCoord : TEXCOORD1;
			LIGHTING_COORDS(0,1)
			
		};


			
		v2f vert(appdata_base v){
	
			v2f o;
			o.pos =UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影


			float3 N = (UnityObjectToWorldNormal(v.normal));// 需要变换到世界空间  这个函数已经做规范化了
			float3 L =normalize(WorldSpaceLightDir(v.vertex));
			float V  =normalize(WorldSpaceViewDir(v.vertex));
				
			//环境光
			//o.color= UNITY_LIGHTMODEL_AMBIENT;//上面已经加了  这里就不需要了
			//Didduse Color
			float angle  =saturate( dot(N,L));
			 o.color =_LightColor0*angle*_MainColor;
		
			//相加得到半角  BilinnPhong
			float3 H  = L+V;
			H=normalize(H);
			 float specularScale =pow( saturate(dot(N,H)),_Glossness);
			 o.color.rgb +=_Specular*specularScale;		
			 
			 TRANSFER_VERTEX_TO_FRAGMENT(o) //在宏定义已经有分号了  不用加了 AutoLightShadow .cginc
				return o  ;
		}
		fixed4 frag(v2f In):COLOR{
			float atten = LIGHT_ATTENUATION(In);
			In.color.rgb*= atten;
			return In.color;
			//return _MainColor;
				

		}
		ENDCG
	}


	}
		
		FallBack"Diffuse"


}