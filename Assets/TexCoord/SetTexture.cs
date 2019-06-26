using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetTexture : MonoBehaviour {

    public float Tiling_x;
    public float Tiling_y;

    public float Offset_x;
    public float Offset_y;
	void Start () {
      

    }
	
	// Update is called once per frame
	void Update () {
        GetComponent<Renderer>().material.SetFloat("tiling_x", Tiling_x);
        GetComponent<Renderer>().material.SetFloat("tiling_y", Tiling_y);
        GetComponent<Renderer>().material.SetFloat("offset_x", Offset_x);
        GetComponent<Renderer>().material.SetFloat("offset_y", Offset_y);
    }
}
