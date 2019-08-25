using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChacactorControl : MonoBehaviour
{

    [SerializeField]
    [Range(0, 100)]
    private float playerSpeend = 1;
    [SerializeField]
    [Range(0, 100)]
    private float rotationY = 1.1f;


    private Animator ani;
    private Rigidbody rig;

    #region Animation ID
    static string moveSpeed = "MoveSpeed";
    static int speedID;

    static string jump = "Jump";
    static int jumpID = 0;

    static string hi = "Hi";
    static int hiID = Animator.StringToHash(hi);

    //Idea的播放时长
    private float playIdeaTime = 0;

    //Hi 的播放次数
  //  int hiCount = 0;
  
    #endregion
    private void Awake()
    {
        ani = GetComponent<Animator>();
        speedID = Animator.StringToHash(moveSpeed);
        jumpID = Animator.StringToHash(jump);
        rig = GetComponentInChildren<Rigidbody>();
    }
    void Start()
    {
    }




    // Update is called once per frame
    void Update()
    {

    }
    private void FixedUpdate()
    {
        // float h = Input.GetAxis("Horizontal");
        float v = Input.GetAxis("Vertical");
        ani.SetFloat(speedID, v);
        AnimatorClipInfo[] clips = ani.GetCurrentAnimatorClipInfo(0);

        if (ani.GetCurrentAnimatorStateInfo(0).IsName("idle"))
        {

            playIdeaTime = ani.GetCurrentAnimatorStateInfo(0).normalizedTime;
            //print(playIdeaTime);
            if (playIdeaTime >= 1.5 )
            {
                ani.SetTrigger(hiID);
             //   ani.ResetTrigger(hiID);
             
            }
     

        }
        //动画是否在过度  很重要的一接口
        //if (ani.IsInTransition(0))
      
        if (Input.GetKeyDown(KeyCode.Space) && !ani.GetCurrentAnimatorStateInfo(0).IsName("jump-up"))
        {
            ani.SetTrigger(jumpID);
            // print(jump.Length);
            //jump[0].clip.n
        }
        else
        {

        }
        if (ani.GetCurrentAnimatorStateInfo(0).IsName("jump-up"))
        {
           // print(ani.GetCurrentAnimatorStateInfo(0).normalizedTime);

        }
    }


    private void OnAnimatorMove()
    {
        Vector3 moveVec = rig.position;// transform.localPosition;
        moveVec.z += ani.GetFloat(speedID) * Time.deltaTime * playerSpeend;
       // rig.MovePosition(moveVec);
        rig.velocity = transform.forward* ani.GetFloat(speedID) * Time.deltaTime * playerSpeend;
        //rig.M

        ///旋转的
        ///
        float h = Input.GetAxis("Horizontal");
        Quaternion rotation = transform.rotation;
        rotation.y += h * rotationY * Time.deltaTime;
       // print(Mathf.Abs(rotation.y - 1));
    
       // print("RotationY" + rotation.y);
        transform.rotation = rotation;
    }
}