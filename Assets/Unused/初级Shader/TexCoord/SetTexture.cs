using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetTexture : MonoBehaviour {
    [Header("dw")]
    public int Width;
    public int Height;
    public int Fps;

    private int currentIndex;
	IEnumerator Start () {

        while (true)
        {
            yield return new WaitForSeconds(1 / Fps);

        }

    }
	
	// Update is called once per frame
	void Update () {
      
    }
}
