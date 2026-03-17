using UnityEngine.Rendering;
using UnityEngine.Rendering.RenderGraphModule;
using UnityEngine.Rendering.RenderGraphModule.Util;
using UnityEngine.Rendering.Universal;

public class CopyPass : ScriptableRenderPass
{
    public CopyPass()
    {
        requiresIntermediateTexture = true;
    }

    public override void RecordRenderGraph(RenderGraph renderGraph, ContextContainer frameData)
    {
        // UniversalResourceData es un cajon desastre de recursos
        UniversalResourceData resourceData = frameData.Get<UniversalResourceData>();

        // cogemos la textura actual
        var source = resourceData.activeColorTexture;

        // creamos la textura destination textura/target/destino nueva
        // cogemos informacion de la textura source
        var destionationDesc = renderGraph.GetTextureDesc(source);
        destionationDesc.name = "CopyPass-Pr8";

        TextureHandle destination = renderGraph.CreateTexture(destionationDesc);

        //creacion de un nodo
        renderGraph.AddCopyPass(source, destination, passName);
    }
}
