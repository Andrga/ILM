#pragma once
#include "Color.h"

class Material {
public:
	Material(Color* baseColor);
	Color* getBaseColor() const { return _baseColor; }
private:
	Color* _baseColor;
};

