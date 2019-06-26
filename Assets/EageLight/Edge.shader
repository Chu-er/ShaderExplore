// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'




Shader"ManNiu/Edge"{
	
	Properties{
		//_MainTex("")
		_MainColor("MainCol",Color) =(1,1,1,1) 
		_Scale("Scale",range(1,8)) = 1
		_Outer ("Outher",range(0,1))=0.2

	}
	SubShader{
			Tags{"queue"="transparent"}

		Pass{
	
		Blend srcalpha oneminussrcalpha
		Zwrite off
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag 
		#include "UnityCG.cginc"
		
		float _Scale;
		float4x4 mvp;
		float _Outer;
		float4 _MainColor;//Properties 
		uniform float4 Colo;//或者使用这个方法也可以进行 ——MainCol的 操作
		


	   	struct v2f{
			float4 pos:POSITION;
			fixed4 color :COLOR;
			float3 normal:TEXCOORD0;
			float4 vertex:TEXCOORD1;
		};

		v2f vert(appdata_base v){
			v2f o ; 
			v.vertex.xyz+=v.normal*_Outer;
			o.pos =  UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影
			o.vertex = v.vertex;
			o.normal = v.normal;
			

			return o;
		}
		fixed4 frag(v2f In):COLOR{
		 float3 N  =UnityObjectToWorldNormal(In.normal);

		 float3 V=normalize( WorldSpaceViewDir(In.vertex));
		
		float bright =saturate( dot(N,V));
		bright =pow(bright,_Scale);
		_MainColor.a*= bright;
			return _MainColor;
		}
		ENDCG
	}
	/////////////////************************88
	Pass{
	
		//Blend srcalpha oneminussrcalpha
		Blend  zero one //直输出上面的  和注释这个Pas一样
		Zwrite off
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag 
		#include "UnityCG.cginc"
		
		float _Scale;
		float4x4 mvp;

		float4 _MainColor;//Properties 
		uniform float4 Colo;//或者使用这个方法也可以进行 ——MainCol的 操作
		


	   	struct v2f{
			float4 pos:POSITION;
			fixed4 color :COLOR;
			float3 normal:TEXCOORD0;
			float4 vertex:TEXCOORD1;
		};

		v2f vert(appdata_base v){
			v2f o ; 
		
			o.pos =  UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影
			o.vertex = v.vertex;
			o.normal = v.normal;
			

			return o;
		}
		fixed4 frag(v2f In):COLOR{
		 float3 N  =UnityObjectToWorldNormal(In.normal);

		 float3 V=normalize( WorldSpaceViewDir(In.vertex));
		
		float bright =1-saturate( dot(N,V));
		bright =pow(bright,_Scale);
			return fixed4(1,1,1,1)*bright;
		}
		ENDCG
	}




	}
		



}