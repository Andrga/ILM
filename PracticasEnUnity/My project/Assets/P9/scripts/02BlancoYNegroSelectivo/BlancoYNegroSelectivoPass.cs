using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.RenderGraphModule;
using UnityEngine.Rendering.RenderGraphModule.Util;
using UnityEngine.Rendering.Universal;


public class BlancoYNegroSelectivoPass : ScriptableRenderPass
{
    Material _mat;
    public void Setup(Material mat, float v) {
        _mat = mat;
        int id = Shader.PropertyToID("_Intensity");
        _mat.SetFloat(id, v);
    }

    class PassData{
        public Material mat;
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
        destionationDesc.name = "BlancoNegro-Pr9";
        TextureHandle destination = renderGraph.CreateTexture(destionationDesc);

        // creamos el nodo
        RenderGraphUtils.BlitMaterialParameters blitParams = 
            new RenderGraphUtils.BlitMaterialParameters(source, destination, _mat, 0);

        renderGraph.AddBlitPass(blitParams, "BlancoNegro-Pr9");
        resourceData.cameraColor = destination;
    }
    static void ExecutePass(PassData data, RasterGraphContext context)
    {
        Blitter.BlitTexture(context.cmd, data.source, new Vector4(1.0f, 1.0f, 0.0f, 0.0f), 0, false);
    }
}
