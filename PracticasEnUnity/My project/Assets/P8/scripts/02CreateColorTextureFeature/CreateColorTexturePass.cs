using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using UnityEngine.Rendering.RenderGraphModule;
using Unity.Mathematics;

public class CreateColorTexturePass : ScriptableRenderPass
{
    Color _color = Color.magenta;
    
    public void Setup(Color color) {
        _color = color;
    }

    class PassData {
        public Color color;
    }
    public override void RecordRenderGraph(RenderGraph renderGraph, ContextContainer frameData) {

        using (var builder = renderGraph.AddRasterRenderPass<PassData>("Crear textura", out var passData)) // añade una renderpass extra (nombre, PassData)
        {

            // UniversalResourceData es un cajon desastre de recursos
            UniversalResourceData resourceData = frameData.Get<UniversalResourceData>();

            // cogemos la textura actual
            var source = resourceData.activeColorTexture;

            // creamos la textura destination textura/target/destino nueva
            // cogemos informacion de la textura source
            var destionationDesc = renderGraph.GetTextureDesc(source);
            destionationDesc.name = "ColorPlano-Pr8";
            TextureHandle destination = renderGraph.CreateTexture(destionationDesc);
            passData.color = _color;
            // Asigna la textura objetivo
            builder.SetRenderAttachment(destination, 0, AccessFlags.Write);
            //builder.SetRenderFunc(static(PassData data, RasterGraphContext context) => ExecutePass(data, context));
            //// Manera compacta de pasar la funcion que ejecuta el pass.
            builder.SetRenderFunc<PassData>(ExecutePass);
            // Unity quita las pasadas que no se usan las texturas, con esta funcion se fuerza a usarlas y que aparezcan en el frame debugger.
            builder.AllowPassCulling(false);





        }
    }

    static void ExecutePass(PassData data, RasterGraphContext context) {
        context.cmd.ClearRenderTarget(true, true, data.color);
    }


}
