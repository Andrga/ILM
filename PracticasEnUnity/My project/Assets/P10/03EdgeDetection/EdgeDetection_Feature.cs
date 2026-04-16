using UnityEngine;
using UnityEngine.Rendering.Universal;
using UnityEngine.Rendering.RenderGraphModule;
using UnityEngine.Rendering;

public class EdgeDetectionFeature : ScriptableRendererFeature
{

    private Material _sbMaterial; 
    [SerializeField] private EdgeDetectionPass m_SBPass; 
    [SerializeField][Range(0.0f,1.0f)] private float factor ; 

    public override void Create()
    {
        m_SBPass = new EdgeDetectionPass();
        m_SBPass.renderPassEvent = RenderPassEvent.AfterRenderingPostProcessing;
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        Shader s = Shader.Find("Hidden/EdgeDetection");
        _sbMaterial = CoreUtils.CreateEngineMaterial(s);

        if (_sbMaterial == null)
        {
            return;
        }

        m_SBPass.Setup(_sbMaterial, factor);
        renderer.EnqueuePass(m_SBPass);
    }
}
