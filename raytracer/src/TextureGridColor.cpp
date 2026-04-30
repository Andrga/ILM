#include "TextureGridColor.h"
#include "TextureConstColor.h"
#include <cmath>

TextureGridColor::TextureGridColor(Color c1, Color c2, float tilesWidth, float tilesHeight) 
	: _tex1(TextureConstColor(c1)), _tex2(TextureConstColor(c2)), _width(tilesWidth), _height(tilesHeight) {}

TextureGridColor::TextureGridColor(Texture tex, Color c, float tilesWidth, float tilesHeight)
	: _tex1(tex), _tex2(TextureConstColor(c)), _width(tilesWidth), _height(tilesHeight) {}

TextureGridColor::TextureGridColor(Color c, Texture tex, float tilesWidth, float tilesHeight)
	: _tex1(TextureConstColor(c)), _tex2(tex), _width(tilesWidth), _height(tilesHeight) {}

TextureGridColor::TextureGridColor(Texture tex1, Texture tex2, float tilesWidth, float tilesHeight)
	: _tex1(tex1), _tex2(tex2), _width(tilesWidth), _height(tilesHeight) {}

Color TextureGridColor::color(float u, float v) const {
	int xInteger = int(std::floor(u * _width));
	int yInteger = int(std::floor(v * _height));

	bool isEven = (xInteger + yInteger) % 2 == 0;

	return isEven ? _tex1.color(u, v) : _tex2.color(u, v);
}
