texture overlayTexture;

technique texReplace
{
    pass P0
    {
        Texture[0] = overlayTexture;
    }
}