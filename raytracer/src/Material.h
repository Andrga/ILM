#pragma once
#include "Color.h"

class Material {
public:
	Material(Color const& baseColor);

	Color getBaseColor() const { return _baseColor; }
private:
	Color _baseColor;
};

