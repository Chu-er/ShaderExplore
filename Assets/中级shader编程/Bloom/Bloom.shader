////Bloom  屏幕后期处理    
//原理 提取像素中的高亮区域  对其进行模糊处理  在与原始图像进行混合
//一般对 高亮区域的迷糊采用高斯模糊 、

//计算方法 需要4个Pass \
//1.得到纹理亮度值（灰度值） 传递给一个临时纹理_Bloom 
//23.单独对 _Bloom 进行高斯
//4 混合原始纹理和 ——Bloom 


Shader "MyUnlit/Bloom"

{
	Properties
	{
		[PerRenderData]_MainTex ("Baby", 2D) = "white" {}
		_Bloom ("Bloom", 2D) ="black"{} //临时 空纹理 存放亮度区域
		_Luminance("Luminance",float) = 0.5
		_offsets("BlurSize",Vector) = (0,0,0,0)
	}
	SubShader
	{
		CGINCLUDE
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			half4  _MainTex_TexelSize; //对应纹理的像素
			sampler2D _Bloom;
			float _Luminance;
			float4 _offsets;

			struct v2f 
			{	
				half2 uv:TEXCOORD0;
				float4 pos:SV_POSITION;
			};
			struct v2Bloom
			{
				//half4 是因为这里要存储——Bloom 纹理
				half4 uv:TEXCOORD0;
				half4 pos:SV_POSITION;

			};
			
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				return o;
			}

			v2Bloom vertBloom(appdata_base v){
				v2Bloom o;
			

				o.pos = UnityObjectToClipPos(v.vertex);
				//xy  存储主纹理 zw存储 ——Bloom 纹理
				o.uv.xy = v.texcoord;
				o.uv.zw = v.texcoord;

				//判断平台差异 directx 纹理坐标原点在左上  OpendGL 在左下
				//Unity 对主纹理以及进行了内部处理  因此我们只对 _Bloom进行判读就行、
				//主要表现在Y 轴的翻转
				#if UNITY_UV_STARTS_AT_TOP
					if (_MainTex_TexelSize.y<0) //检测我们是否开启了抗锯齿
					{
						o.uv.w = 1-o.uv.w;
					}

				#endif
				//o.uv.z = 1-o.uv.z;
				return o;
			}
			//提取超过 亮度阙值的 颜色
			fixed4 fragExtractBright(v2f In):SV_TARGET{
				fixed4 col = tex2D(_MainTex,In.uv);
				fixed val = clamp( Luminance(col)- _Luminance,0,1 );
				return col*val;
			}

			//对xy 和 zw的对应采样结果进行混合
			fixed4 fragBloom(v2Bloom In):SV_TARGET{
				
				return tex2D(_MainTex,In.uv.xy) +tex2D(_Bloom,In.uv.zw);

			}

		ENDCG
		
		ZTest Always
		Cull off
		ZWrite off

		////提亮步
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment fragExtractBright
	
			ENDCG
		}
		//Pass 2 复用高斯 对上面提亮的区域进行模糊处理\
	
		UsePass"MyUnlit/GaussianBlur/GAUSSIANBLURPASS"


		Pass
		{
			CGPROGRAM
				#pragma vertex vertBloom
				#pragma fragment fragBloom
			ENDCG
		}

	}

	Fallback off
}
