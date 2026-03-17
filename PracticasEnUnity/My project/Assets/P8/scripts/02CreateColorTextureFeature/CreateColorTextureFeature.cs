using UnityEngine;
using UnityEngine.Rendering.Universal;

public class CreateColorTextureFeature : ScriptableRendererFeature
{
    [SerializeField] private Color colorRelleno;

    CreateColorTexturePass customPass;

    public override void Create() {
        customPass = new CreateColorTexturePass();
        customPass.renderPassEvent = RenderPassEvent.AfterRenderingOpaques;
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData) {
        customPass.Setup(colorRelleno);
        renderer.EnqueuePass(customPass);
    }
}