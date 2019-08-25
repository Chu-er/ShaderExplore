using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostBloom : MonoBehaviour {

    private readonly string _LuminanceThreshlod = "_Luminance";
    private const string _BlurSize = "_offsets";
    private readonly string _Blooom = "_Bloom";

    // private readonly  string 
    [Range(0, 4)] //模糊次数
    public int iteration = 3;
    [Range(0.2f, 3f)]
    public float blurSize = 0.6f;

    [Range(1, 8)] //屏幕宽高的缩放倍数
    public int downSample = 2;


    public float LuminanceThreShlod = 0.6f;//控制Bloom 效果的亮度 阙值，因为亮度值大多时候不大于1 超过1
                                           //一般无效果 但开启了HDR后图像的亮度取值范围将扩大


    public Material Matbloom;
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (Matbloom != null)
        {
            Matbloom.SetFloat(_LuminanceThreshlod, LuminanceThreShlod);

            int rth = source.height / downSample;
             int ttw = source.width / downSample;

            //临时渲染纹理
            RenderTexture buffer0 = RenderTexture.GetTemporary(ttw, rth, 0);
            buffer0.filterMode = FilterMode.Bilinear;

            //第一个pass 中提取的亮度 存到buffer0 一边候面高斯
            Graphics.Blit(source, buffer0, Matbloom, 0);

            RenderTexture buffer1 = RenderTexture.GetTemporary(ttw, rth, 0);
            //
          for (int i = 0; i < iteration; i++)
          {
              Matbloom.SetVector(_BlurSize, new Vector4(i*blurSize+1, i * blurSize + 1, 0, 0));
         
         
              if (i==0)
              {
                  //将高斯完后的拷贝到新纹理
                  Graphics.Blit(buffer0, buffer1, Matbloom, 1);
                  RenderTexture.ReleaseTemporary(buffer0);
              }
              else
              {
                  buffer0 = RenderTexture.GetTemporary(ttw, rth, 0);
                  Graphics.Blit(buffer0, buffer1, Matbloom, 1);
                  RenderTexture.ReleaseTemporary(buffer0);
              }
         
              
            }

            //将高斯模糊的结果给——bloom 进行最后的混合
            Matbloom.SetTexture(_Blooom, buffer0);
            Graphics.Blit(source,  destination, Matbloom, 2);
            RenderTexture.ReleaseTemporary(buffer1);



        }
    }
}
