// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'




Shader"ManNiu/Today2"{
	
	Properties{
		//_MainTex("")
		_MainColor("MainCol",Color) =(1,1,1,1) 
		_R("R",range(0,5)) = 1
		_OX("OX",range(-5,5))  = 0//他的目的是为了改变世界得00点
	}
	SubShader{
		//Cull off  //正背面剔除
	Pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag 
		#include "UnityCG.cginc"
		

		float4x4 mvp;

		float4 _MainColor;//Properties 
		uniform float4 Colo;//或者使用这个方法也可以进行 ——MainCol的 操作
		float _R;
		float _OX;

	   	struct v2f{
			float4 pos:POSITION;
			fixed4 color :COLOR;
		};

		v2f vert(appdata_base v){

			float4 wPos =mul( unity_ObjectToWorld,v.vertex);//模型到世界得顶点
		    	
			float2 xy = wPos.xz;// 平面得顶点 所以是XZ坐标
			//获取向量长度
			float dis = _R-length(xy-float2(0,_OX)); //其实就是平方再开平方    ——OX 目的改变 开始变换得中心点

			dis=dis<0 ? 0:dis; // dis 的结果可能是个负数 所以要对他 进行 

			float height = 0.56;//高度

			float4 upPos = float4(v.vertex.x ,height*dis,v.vertex.z,v.vertex.w);
			v2f o ; 

			o.pos =  UnityObjectToClipPos(upPos);  //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影
			o.color = fixed4(upPos.y,upPos.y,upPos.y,1);//(upPos.y,upPos.y,upPos.y,1);
			return o;
		}
		fixed4 frag(v2f In):COLOR{
			return In.color;
			//return _MainColor;
				

		}
		ENDCG
	}




	}
		



}