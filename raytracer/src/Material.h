#pragma once
#include "Color.h"

class Material {
public:
	Material(Color const& baseColor, float reflexFactor = 0.0f);

	Color getBaseColor() const { return _baseColor; }
	float getReflexFactor() const { return _reflexFactor; }
private:
	Color _baseColor;
	float _reflexFactor; // factor d reflexion
};

