using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NodePosition : MonoBehaviour {

    public float nodeDis = 1;
    public Transform LastNode;
    float realDis;
    float allowValue = 0.02f;
    Rigidbody2D rig;
	void Start () {
        rig = GetComponent<Rigidbody2D>();
	}
	
	// Update is called once per frame
	void Update () {
        judge();
        decelerration();
	}
    /// <summary>
    /// 求俩点得结合
    /// </summary>
    void judge()
    {
        ///用平方来算
        realDis = Vector3.Magnitude(LastNode.position - transform.position);
        if (realDis > Mathf.Pow(nodeDis, 2) || realDis < nodeDis * nodeDis - allowValue)
        {
            transform.position = Vector3.Lerp(LastNode.position, transform.position, nodeDis / realDis);

        }
    }
    /// <summary>
    /// 减速
    /// </summary>
    void decelerration()
    {
        float veloCity = Vector2.SqrMagnitude(rig.velocity);
        if( veloCity > 25)
        {
            rig.velocity /= 3;
        }
        Debug.Log(veloCity + "速度");
    }
}
