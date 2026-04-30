#pragma once
#include <memory>

#include "Texture.h"
class TextureGridColor : public Texture {
public:
	/*TextureGridColor(Color c1, Color c2, float tilesWidth = 4.0f, float tilesHeight = 4.0f);
	TextureGridColor(std::shared_ptr<Texture> tex, Color c, float tilesWidth = 4.0f, float tilesHeight = 4.0f);
	TextureGridColor(Color c, std::shared_ptr<Texture> tex, float tilesWidth = 4.0f, float tilesHeight = 4.0f);*/
	TextureGridColor(std::shared_ptr<Texture> tex1, std::shared_ptr<Texture> tex2, float tilesWidth = 4.0f, float tilesHeight = 4.0f);

	Color color(float u, float v) const override;

private:
	std::shared_ptr<Texture> _tex1; std::shared_ptr<Texture> _tex2;
	float _width; float _height;
};

