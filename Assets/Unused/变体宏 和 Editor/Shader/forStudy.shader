Shader "Custom/forStudy"
{
	Properties
	{		
	//biaoti
		[Header(Material Propertiy Drawer Example)]
		[Space]//目的是一个空行
		[Space(30)]
		_MainTex ("Texture", 2D) = "white" {}
		_SecondTex("SecondTex",2D)=  "white"{}


		//当他是 on  那么一个Shader关键字将设置 大写+_ON 
		[Toggle]_Invert("Invert color?",float) = 1
		[Space(5)]
		 // Will set "ENABLE_FANCY" shader keyword when set
        [Toggle(ENABLE_FANCY)] _Fancy ("Fancy?", Float) = 0

		//Enum 
		[Enum(UnityEngine.Rendering.BlendMode)]_SrcBlend("SrcBlend",float)=1
		[Enum(UnityEngine.Rendering.BlendMode)]_DstBlend("DstBlend",float)=1
		[Enum(off,0,On,1)]_Zwrite("Zwrite",float) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTest ("ZTest",float)=0 
		[Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull",float) =0

		///keywor显示**float**属性的弹出菜单，并启用相应的着色器关键字。
//这与着色器中的“#pragma multi_compile”一起使用，以启用或禁用着色器代码的某些部分。
//每个名称将启用“property name”+下划线+“enum name”，大写，着色器关键字。
		[KeywordEnum(None,Add,Multiply)]_Overlay("OverlayMode",Float) = 0

		 // PowerSlider displays a slider with a non-linear response for a Range shader property.
        // A slider with 3.0 response curve
        [PowerSlider(3.0)] _Shininess ("Shininess", Range (0.01, 1)) = 0.08
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"  ="Transparent" }
		

		LOD 100

		Pass
		{
			Blend [_SrcBlend] [_DstBlend]
			ZWrite[_Zwrite]
			ZTest[_ZTest]
			Cull[_Cull]


			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#pragma shader_feature _INVERT_ON

			#pragma shader_feature ENABLE_FANCY
			#pragma multi_compile _OVERLAY_NONE _OVERLAY_ADD _OVERLAY_MULITILAY

			#include "UnityCG.cginc"

			CBUFFER_START(MyCustomCbuffer)
				sampler2D _MainTex;
				sampler2D _SecondTex;
				float _Shininess;
			  float4 _MainTex_ST;
			   float4 _SecondTex_ST;
			CBUFFER_END
		


			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
			
				float4 vertex : SV_POSITION;
			};

			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.uv, _SecondTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
			
				fixed4 col = tex2D(_MainTex, i.uv.xy);
				///使用宏
				#if _INVERT_ON
					col =1-col;
				#endif

				#ifdef ENABLE_FANCY //同上  OR #ifdefined
					col.r= 0.5;
				#endif
				fixed4 secCol = tex2D(_SecondTex,i.uv.zw);


				#if _OVERLAY_ADD 
					col+=secCol;
				#endif
				#if _OVERLAY_MULITILAY
					col*=secCol;
				#endif
				col*=_Shininess;
				return col;
			}
			ENDCG
		}
	}
}
