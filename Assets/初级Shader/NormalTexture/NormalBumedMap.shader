Shader "Custom/NormalBumedMap" {
	Properties {
		_BumpTex("NormalMap",2D) = ""{}
	}
	SubShader {
		Tags { "Queue"="Geometry" }
		LOD 200
		Pass{
			Tags{"LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		 #pragma fragment farg
		 #include "unitycg.cginc"
		 #include "lighting.cginc"
		 sampler _BumpTex;


		 struct V2f{
			float4 pos:POSITION;
			float2  uv :TEXCOORD0;
			float wpos:TEXCOORD1;
			float3 lightDir:TEXCOORD2;
		 };

		 V2f vert(appdata_tan v){
			V2f o ;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.wpos = mul(unity_ObjectToWorld,v.vertex).xyz;
			//求副法线
			//float3 binormal = cross(v.tangent.xyz,v.normal);
			//方法1  自己计算//把灯光方向变换到切线空间
			//float3x3 rotation = float3x3(v.tangent.xyz,binormal,v.normal);
			//方法2  使用BuiltIn 
			TANGENT_SPACE_ROTATION ;

			o.lightDir = mul(rotation,_WorldSpaceLightPos0.xyz);
			o.uv = v.texcoord.xy;
			return o;
		 }
		 fixed4 farg(V2f In):COLOR{
		 //归一化切线空间的光位置
		 float3 L = normalize(In.lightDir);
		 float3 N = UnpackNormal(tex2D(_BumpTex,In.uv));
		 N =normalize(N);
		 float ndotl = saturate(dot(N,L));
			fixed4 col  =_LightColor0*ndotl;
		 	col.rgb += Shade4PointLights(unity_4LightPosX0,unity_4LightPosY0,unity_4LightPosZ0,
			unity_LightColor[0].rgb,unity_LightColor[1].rgb,unity_LightColor[2].rgb,unity_LightColor[3].rgb,
			unity_4LightAtten0,In.wpos,N);

		  return col+UNITY_LIGHTMODEL_AMBIENT;
		 }
		ENDCG


		}
		
	}
	FallBack "Diffuse"
}
