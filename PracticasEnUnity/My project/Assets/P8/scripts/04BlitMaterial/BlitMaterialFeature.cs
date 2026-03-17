using UnityEngine;
using UnityEngine.Rendering.Universal;

public class BlitMaterialFeature : ScriptableRendererFeature
{
    BlitMaterialPass blitMaterial;

    [SerializeField] private Material _material; 
    
    public override void Create() {
        blitMaterial = new BlitMaterialPass();
        blitMaterial.renderPassEvent = RenderPassEvent.AfterRenderingOpaques;
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData) {
        renderer.EnqueuePass(blitMaterial);
    }
}