using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LineRenderHandle : MonoBehaviour {
   // ScriptableObject ss;
    LineRenderer line;
    public Transform[] TransNode;
    Vector3[] node;
    bool isCaculata = false;
	void Start () {
        line = GetComponent<LineRenderer>();
        line.positionCount = TransNode.Length;
       // node = new Vector3[TransNode.Length];
       
        isCaculata = true;
    }
	
    
	void LateUpdate () {
            if(!isCaculata) return;
        node = new Vector3[] { TransNode[0].position, TransNode[1].position, TransNode[2].position };
        line.SetPositions(node);
      
	}
}
