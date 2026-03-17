using UnityEngine;
using UnityEngine.Rendering.Universal;

public class MyCopyPassFeature : ScriptableRendererFeature
{
    MyCopyPass myCopyPass;

    public override void Create() {
        myCopyPass = new MyCopyPass();
        myCopyPass.renderPassEvent = RenderPassEvent.AfterRenderingOpaques;
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData) {
        renderer.EnqueuePass(myCopyPass);
    }
}