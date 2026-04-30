#pragma once
#include "Texture.h"
class TextureGridColor : public Texture {
public:
	TextureGridColor(Color c1, Color c2, float tilesWidth = 4.0f, float tilesHeight = 4.0f);
	TextureGridColor(Texture tex, Color c, float tilesWidth = 4.0f, float tilesHeight = 4.0f);
	TextureGridColor(Color c, Texture tex, float tilesWidth = 4.0f, float tilesHeight = 4.0f);
	TextureGridColor(Texture tex1, Texture tex2, float tilesWidth = 4.0f, float tilesHeight = 4.0f);

	Color color(float u, float v) const override;

private:
	Texture _tex1; Texture _tex2;
	float _width; float _height;
};

