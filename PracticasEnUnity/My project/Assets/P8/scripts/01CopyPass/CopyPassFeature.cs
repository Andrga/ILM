using UnityEngine.Rendering.Universal;

public class CopyPassFeature : ScriptableRendererFeature
{

    private CopyPass m_ScriptablePass;

    public override void Create()
    {
        m_ScriptablePass = new CopyPass();

        m_ScriptablePass.renderPassEvent = RenderPassEvent.AfterRenderingOpaques;

    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        renderer.EnqueuePass(m_ScriptablePass);
    }
}
