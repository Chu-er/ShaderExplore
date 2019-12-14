using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaveTexture : MonoBehaviour {

    public int WaveWidth;
    public int WaveHeight;

    /// <summary>
    /// 
    /// </summary>
    float[,] waveA;
    float[,] waveB;


    Texture2D txe_uv;
	void Start () {
        waveA = new float[WaveWidth, WaveHeight];
        waveB = new float[WaveWidth, WaveHeight];
        txe_uv = new Texture2D(WaveWidth, WaveHeight);


    }
	
	// Update is called once per frame
	void Update () {
         
        computeWave(); 

    }


    void computeWave()
    {
        for (int w = 0; w < WaveWidth; w++)
        {
            for (int h = 0; h < WaveHeight; h++)
            {
                waveB[w, h] = waveA[w - 1, h];
            }
        }
    }
}
