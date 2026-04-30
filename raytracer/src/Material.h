#pragma once
#include "Color.h"
#include "Texture.h"

class Material {
public:
	Material(Color const& baseColor, float reflexFactor = 0.0f);
	Material(Texture* tex, float reflexFactor = 0.0f);

	Color getBaseColor() const { return _baseColor; }
	Color getBaseColor(float u, float v) const { 
		if (_texture != nullptr) {
			return _texture->color(u, v); 
		}
		else {
			return _baseColor;
		}
	}
	float getReflexFactor() const { return _reflexFactor; }
private:
	Texture* _texture;
	Color _baseColor;
	float _reflexFactor; // factor d reflexion
};

