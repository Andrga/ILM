using UnityEngine;
using UnityEngine.Rendering.Universal;
using UnityEngine.Rendering.RenderGraphModule;
using UnityEngine.Rendering;

public class BlancoYNegroSelectivoFeature : ScriptableRendererFeature {
    private Material _bwMaterial; // black white material
    private BlancoYNegroPass m_BWPass; // black white pass
    [SerializeField] private float value; // black white pass
    [SerializeField] private LayerMask mask; // black white pass

    public override void Create()
    {
        m_BWPass = new BlancoYNegroPass();
        m_BWPass.renderPassEvent = RenderPassEvent.AfterRenderingOpaques;
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
