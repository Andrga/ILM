#pragma once
#include "Texture.h"
class TextureConstColor : public Texture {
public: 
	TextureConstColor(Color c);
	Color color(float u, float v) const override;
private:
	Color _constColor;
};

