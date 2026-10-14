// Variable(s)
texture ScreenSource;
float BlurStrenght;
float2 UVSize;
float Time;

// Function(s)
sampler TextureSampler = sampler_state {
    Texture = <ScreenSource>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
};

static const float2 poisson[16] = {
    float2(-0.326212f, -0.40581f),
    float2(-0.840144f, -0.07358f),
    float2(-0.695914f, 0.457137f),
    float2(-0.203345f, 0.620716f),
    float2(0.96234f, -0.194983f),
    float2(0.473434f, -0.480026f),
    float2(0.519456f, 0.767022f),
    float2(0.185461f, -0.893124f),
    float2(0.507431f, 0.064425f),
    float2(0.89642f, 0.412458f),
    float2(-0.32194f, -0.932615f),
    float2(-0.65432f, -0.87421f),
    float2(-0.456899f, -0.633247f),
    float2(-0.123456f, -0.865433f),
    float2(-0.664332f, -0.25680f),
    float2(-0.791559f, -0.59771f)
};

float4 PixelShaderFunction(float2 TextureCoordinate : TEXCOORD0) : COLOR0 {
    // Variable(s)
    float startValue = 0;
    float endValue = 0.8;

    float time = lerp(startValue, endValue, abs(sin(0.5 * Time))); // Interpolation linéaire entre les valeurs de départ et de fin
    float2 louchantCoord = TextureCoordinate + (float2(0.003f, 0.0f) * BlurStrenght * time);
    float4 color = tex2D(TextureSampler, louchantCoord);

    // Loop: Through the poisson array (16 times)
    for(int i = 0; i < 16; i++) {
        float2 coord = TextureCoordinate.xy + (poisson[i] / UVSize * (BlurStrenght * 0.2f * time));
        color += tex2D(TextureSampler, coord);
    }

    // Effect: Blur & Double Vision
    float2 halfTextureCoord = TextureCoordinate;
    halfTextureCoord.x = halfTextureCoord.x * (1.0f - time * 0.1f);
    float4 mirroredColor = tex2D(TextureSampler, halfTextureCoord);

    // Return
    return (color / 18) + (mirroredColor * 0.3f);
}

technique BlurShader {
    pass Pass1 {
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}