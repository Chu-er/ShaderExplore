using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System;
public class CustomShaderEditor : ShaderGUI {


    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        base.OnGUI(materialEditor, properties);


        Material target = materialEditor.target as Material;
        //bool enableFancy = Array.IndexOf(target.shaderKeywords, "ENABLE_FANCY") != -1;
        //检测贴图是否为空
      
        MaterialProperty secondTex = FindProperty("_SecondTex", properties);
        EditorGUI.BeginChangeCheck();
        bool isHas = secondTex.textureValue != null;

       
        if (EditorGUI.EndChangeCheck())
        {
            if (isHas)
            {
                target.EnableKeyword("ENABLE_FANCY"); Debug.Log("没有用这个");
            }
            else
            {
                target.DisableKeyword("ENABLE_FANCY");
                Debug.Log("没有用这个");
            }
        }
    }

}
