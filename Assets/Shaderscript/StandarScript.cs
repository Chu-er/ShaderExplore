using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StandarScript : MonoBehaviour {

    // Use this for initialization

   // Renderer Re;
	void Start () {
       //GetComponent<Renderer>().material.SetVector("Colo",new Vector4(1,0,0,1));
	}
	
	// Update is called once per frame
	void Update () {

        //Vector4 jj = new Vector4()
        Matrix4x4 Rm = new Matrix4x4();
        
        Rm[0, 0] = Mathf.Cos(Time.realtimeSinceStartup);
        Rm[0, 2] = Mathf.Sin(Time.realtimeSinceStartup);
        Rm[1, 1] = 1;
        Rm[2, 0] = -Mathf.Sin(Time.realtimeSinceStartup);
        Rm[2,2] = Mathf.Cos(Time.realtimeSinceStartup);
        Rm[3, 3] = 1;
        Matrix4x4 mvp = Camera.main.projectionMatrix* Camera.main.worldToCameraMatrix * transform.localToWorldMatrix*Rm;
        GetComponent<Renderer>().material.SetMatrix("mvp", Rm);
        

	}
}
