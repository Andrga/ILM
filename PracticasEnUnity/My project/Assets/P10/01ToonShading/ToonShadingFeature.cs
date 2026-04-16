using UnityEngine;
using UnityEngine.Rendering.Universal;
using UnityEngine.Rendering.RenderGraphModule;
using UnityEngine.Rendering;

public class ToonShadingFeature : ScriptableRendererFeature
{

    private Material _tMaterial; // black white material
    [SerializeField] private ToonShadingPass m_TPass; // black white pass
    [SerializeField][Range(0,10)] private float factor ; // black white pass

    public override void Create()
    {
        m_TPass = new ToonShadingPass();
        m_TPass.renderPassEvent = RenderPassEvent.AfterRenderingPostProcessing;
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        Shader s = Shader.Find("Hidden/ToonShading");
        _tMaterial = CoreUtils.CreateEngineMaterial(s);

        if (_tMaterial == null)
        {
            return;
        }

        m_TPass.Setup(_tMaterial, factor);
        renderer.EnqueuePass(m_TPass);
    }
}
