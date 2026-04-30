#pragma once
#include "Color.h"

class Texture {
public:
	Texture() {}
	virtual Color color(float u, float v) const { return WHITE; }
};

