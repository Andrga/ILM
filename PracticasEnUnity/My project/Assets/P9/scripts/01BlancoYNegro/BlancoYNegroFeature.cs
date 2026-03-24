using UnityEngine;
using UnityEngine.Rendering.Universal;
using UnityEngine.Rendering.RenderGraphModule;
using UnityEngine.Rendering;

public class BlancoYNegroFeature : ScriptableRendererFeature {
    [SerializeField] private Material _bwMaterial; // black white material
    [SerializeField] private BlancoYNegroPass m_BWPass; // black white pass
    [SerializeField] private float value; // black white pass

    public override void Create()
    {
        m_BWPass = new BlancoYNegroPass();
        m_BWPass.renderPassEvent = RenderPassEvent.AfterRenderingPostProcessing;
    }

    protected override void Dispose(bool disposing){
        base.Dispose(disposing);
        CoreUtils.Destroy(_bwMaterial);
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        if (value == 0) return;
        Shader s = Shader.Find("Hidden/BlancoYNegro");
        _bwMaterial = CoreUtils.CreateEngineMaterial(s);

        if(_bwMaterial == null) {
            return;
        }

        m_BWPass.Setup(_bwMaterial, value);
        renderer.EnqueuePass(m_BWPass);
    }
}
