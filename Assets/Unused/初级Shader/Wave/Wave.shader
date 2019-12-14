

Shader"ManNiu/Wave"{
	
	Properties{
	[Header(Wave Effect)]
	[Space]
	[PerRenderData]_MainTex ("MainTex",2D)=  "white"{}
	[Space]
	_WaveStrength("WavbeStrength",Range(0,1)) = 0.01
	[Space]
	_WaveFactor ("WaveFator",Range(0,150)) = 50
	[Space]
	_TimeScale ("TimeScale",Range(0,20)) = 10



	}
	SubShader{
		//Cull off  //正背面剔除


	Pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag 
		#include "UnityCG.cginc"

		sampler2D _MainTex;
		float4 _MainTex_ST;

		float _WaveStrength;
		float _WaveFactor;
		float _TimeScale;

		


	   	struct v2f{
			float4 pos:POSITION;
			float2 uv:TEXCOORD;

		};


				
		v2f vert(appdata_base v){

		 v2f o;
			
			float s;
			float c;
			sincos(radians(-90),s,c);
			float3x3 rotation=
			{
				c,s,0,
				-s,c,1,
				0,0,0
			};
			float3 vertex =  mul(rotation,v.vertex.xyz);
			o.pos =UnityObjectToClipPos(vertex);  //UnityObjectToClipPos(v.vertex); 模型到世界 相机 投影
			o.uv=  TRANSFORM_TEX(v.texcoord,_MainTex);

			return o  ;
		}
		static fixed2 uvCednter = {0.5,0.5};
		fixed4 frag(v2f In):COLOR{
			//计算出uv上每个点 到中心点 0.5 0.5 的Direction 
			//只求方向 也就是对这些 方向的 uv 点进行变换
			fixed factor = 1;//step(0.5,In.uv.x); // x >0.5 返回 1  否则为0
			fixed2 uvDir =   In.uv*factor - uvCednter*factor;

			// 按照距离中心点的偏移程度  求出距离 每个点到中心的距离
			fixed dis = distance(In.uv,uvCednter);



			fixed2 uv = In.uv + _WaveStrength*uvDir*sin(_Time.y*_TimeScale+(1-dis)*_WaveFactor); //1 - dis  取反了;
			
			//if (In.uv.x >0.5) {
			//	uv= In.uv+_WaveStrength*uvDir*sin(_Time.y*_TimeScale+(1-dis)*_WaveFactor); //1 - dis  取反了 
			//}
			//else 
			//uv = In.uv;
			 
			return tex2D(_MainTex,uv);


				

		}
		ENDCG
	}




	}
		

		FallBack"Diffuse"

}