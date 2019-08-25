
Shader"Custom/2DRotate"{
	SubShader{
		Pass{
		 	CGPROGRAM
		#pragma vertex  vert
		#pragma fragment frag

		void Function();//前向定义

		void vert(in float2 objPos:POSITION,out float4 pos:POSITION, out float4 col:COLOR){
			pos=float4(objPos,0,1);
			col  = float4(0,0,1,1); 
		}
		void Function(  )//自定义函数再调用之前要将进行赋值除非进行前向定义
		{
			
		}
		void frag(inout float4 col:COLOR){//inout 代表既是从顶点传进来的 同时也会输出
			col=float4(1,0,0,1);

			//float r = 1;
			//float g = 0;
			//float b  =0;
			//float a =1;
			bool bl = true;
			col = bl ? col:float4(1,1,1,1);
		}
	
		ENDCG
		}

	}


}
	






