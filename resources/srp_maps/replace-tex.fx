#include "mta-helper.fx"

texture gTexture;

float gRed = 1.0;
float gGreen = 1.0;
float gBlue = 1.0;
float gAlpha = 1.0;

sampler2D gTextureSampler = sampler_state
{
    Texture = ( gTexture );
    MinFilter = Linear;
    MagFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
};

struct VertexShaderInput
{
    float4 Position : POSITION0;
    float4 Diffuse 		: COLOR0;
    float2 TextureCoordinate : TEXCOORD0;
};

struct PixelShaderInput
{
    float4 Position : POSITION0;
    float4 Color    : COLOR0;
    float2 TextureCoordinate : TEXCOORD0;
};

PixelShaderInput VertexShaderFunction ( VertexShaderInput input )
{
    PixelShaderInput output;
    
    float4 worldPosition = mul ( input.Position, gWorld );
    float4 viewPosition  = mul ( worldPosition, gView );
    output.Position      = mul ( viewPosition, gProjection );
    output.Color = MTACalcGTABuildingDiffuse( input.Diffuse );
    output.TextureCoordinate = input.TextureCoordinate;
    return output;
}

float4 PixelShaderFunction ( PixelShaderInput output ) : COLOR0
{
    float2 textureCoordinate = output.TextureCoordinate;

    float4 textureColor = tex2D ( gTextureSampler, textureCoordinate ) * output.Color;
    
    textureColor.r=textureColor.r * gRed;
    textureColor.g=textureColor.g * gGreen;
    textureColor.b=textureColor.b * gBlue;
    // textureColor.a = gAlpha;
    return textureColor;
    
}

technique TexReplace
{
    pass P0
    {
        // AlphaBlendEnable = TRUE;
        // SrcBlend = SRCALPHA;
        // DestBlend = INVSRCALPHA;
        VertexShader = compile vs_2_0 VertexShaderFunction ( );
        PixelShader  = compile ps_2_0 PixelShaderFunction  ( );
    }
}