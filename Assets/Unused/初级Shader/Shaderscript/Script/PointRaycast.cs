using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PointRaycast : MonoBehaviour {

    private GameObject[] items = new GameObject[2];
    private RectTransform PrefabParent;
    private void Awake()
    {
       // LayerId = LayerMask.NameToLayer("Default");
        PrefabParent = transform.Find("PrefabParent").GetComponent<RectTransform>();
        Transform trans = transform.Find("ItemPrefab");
        for (int i = 0; i < trans.childCount-1; i++)
        {//items.
            items[i] = trans.GetChild(i).gameObject;
        }
    }
    void Start () {
		
	}
	

	void Update () {
        //   Debug.Log("TouchCount=" + Input.touchCount);
        if (Input.GetMouseButtonDown(0))
        {
            print("进入");
            // Collider2D col[] = Physics2D.OverlapPointAll(Camera.main.ScreenToWorldPoint(Input.mousePosition));
            Collider2D col = Physics2D.OverlapPoint(Camera.main.ScreenToWorldPoint(Input.mousePosition));
            RaycastHit2D hit = Physics2D.Raycast(Camera.main.ScreenToWorldPoint(Input.mousePosition), Vector2.zero);
           // RayCadstTarget Hit;
       //    Physics2D .OverlapArea()
            //  print(col.name);
            if (hit.collider != null)
            {

                print("碰到了" + hit.collider.name);

            }
            if (col)
            {

                print("碰到了");

            }

        }
      

    
    }
}
