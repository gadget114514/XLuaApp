using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Windows;
using XLua;

namespace XLuaApp
{
    public class XLuaAppLoader : MonoBehaviour
    {

        [SerializeField]
        public string xluaname = "";
        [SerializeField]
        public string basedir = "Resources/xluaapp";

        void Awake()
        {
            LuaEnv luaenvScriptCtrl = new LuaEnv();
            LuaEnv.CustomLoader method = CustomLoaderMethod;

            luaenvScriptCtrl.AddLoader(method);

            if (xluaname == "")
              xluaname = this.name;
            luaenvScriptCtrl.DoString(@" require('" + xluaname + @"')");
        }


        private byte[] CustomLoaderMethod(ref string fileName)
        {
            Debug.Log(fileName);

            fileName = Application.dataPath + "/" + basedir + "/" + fileName.Replace('.', '/') + ".lua";
            if (File.Exists(fileName))
            {
                return File.ReadAllBytes(fileName);
            }
            else
            {
                return null;
            }
        }

    }
}
